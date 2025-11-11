<?php
require_once '../config.php';

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(['success' => false, 'message' => 'Not authenticated']);
    exit;
}

$userId = $_SESSION['user_id'];
$conn = getDBConnection();

// GET - Retrieve user progress
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $conn->prepare("
        SELECT module_id, completed, completed_at, score, flags_found
        FROM user_progress
        WHERE user_id = ?
    ");
    
    if (!$stmt) {
        http_response_code(500);
        echo json_encode([
            'success' => false, 
            'message' => 'Database error',
            'error' => $conn->error
        ]);
        $conn->close();
        exit;
    }
    
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $progress = [];
    $totalCompleted = 0;
    $totalFlags = 0;
    
    while ($row = $result->fetch_assoc()) {
        $progress[$row['module_id']] = [
            'completed' => (bool)$row['completed'],
            'completed_at' => $row['completed_at'],
            'score' => (int)$row['score'],
            'flags_found' => (int)$row['flags_found']
        ];
        
        if ($row['completed']) {
            $totalCompleted++;
        }
        $totalFlags += (int)$row['flags_found'];
    }
    
    $stmt->close();
    
    echo json_encode([
        'success' => true,
        'progress' => $progress,
        'stats' => [
            'modules_completed' => $totalCompleted,
            'total_modules' => 12,
            'flags_captured' => $totalFlags,
            'completion_percentage' => round(($totalCompleted / 12) * 100)
        ]
    ]);
}

// POST - Update module progress
elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (json_last_error() !== JSON_ERROR_NONE) {
        http_response_code(400);
        echo json_encode([
            'success' => false, 
            'message' => 'Invalid JSON data'
        ]);
        exit;
    }
    
    if (!isset($input['module_id'])) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Missing module_id']);
        exit;
    }
    
    $moduleId = $input['module_id'];
    $completed = isset($input['completed']) ? (int)$input['completed'] : 0;
    $score = isset($input['score']) ? (int)$input['score'] : 0;
    $flagsFound = isset($input['flags_found']) ? (int)$input['flags_found'] : 0;
    
    // Check if progress exists
    $checkStmt = $conn->prepare("SELECT id FROM user_progress WHERE user_id = ? AND module_id = ?");
    if (!$checkStmt) {
        http_response_code(500);
        echo json_encode([
            'success' => false, 
            'message' => 'Database error',
            'error' => $conn->error
        ]);
        $conn->close();
        exit;
    }
    
    $checkStmt->bind_param("is", $userId, $moduleId);
    $checkStmt->execute();
    $checkResult = $checkStmt->get_result();
    $exists = $checkResult->num_rows > 0;
    $checkStmt->close();
    
    if ($exists) {
        // Update existing progress
        $stmt = $conn->prepare("
            UPDATE user_progress 
            SET completed = ?, score = ?, flags_found = ?, 
                completed_at = IF(? = 1, NOW(), completed_at),
                updated_at = NOW()
            WHERE user_id = ? AND module_id = ?
        ");
        if (!$stmt) {
            http_response_code(500);
            echo json_encode([
                'success' => false, 
                'message' => 'Database error',
                'error' => $conn->error
            ]);
            $conn->close();
            exit;
        }
        $stmt->bind_param("iiiiis", $completed, $score, $flagsFound, $completed, $userId, $moduleId);
    } else {
        // Insert new progress
        $stmt = $conn->prepare("
            INSERT INTO user_progress (user_id, module_id, completed, score, flags_found, completed_at)
            VALUES (?, ?, ?, ?, ?, IF(? = 1, NOW(), NULL))
        ");
        if (!$stmt) {
            http_response_code(500);
            echo json_encode([
                'success' => false, 
                'message' => 'Database error',
                'error' => $conn->error
            ]);
            $conn->close();
            exit;
        }
        $stmt->bind_param("isiiii", $userId, $moduleId, $completed, $score, $flagsFound, $completed);
    }
    
    if ($stmt->execute()) {
        echo json_encode([
            'success' => true,
            'message' => 'Progress updated successfully'
        ]);
    } else {
        http_response_code(500);
        echo json_encode([
            'success' => false, 
            'message' => 'Failed to update progress',
            'error' => $stmt->error
        ]);
    }
    
    $stmt->close();
}

else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}

$conn->close();
?>