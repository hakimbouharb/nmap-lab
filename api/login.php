<?php
require_once '../config.php';

// Only accept POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit;
}

// Get JSON input
$rawInput = file_get_contents('php://input');
$input = json_decode($rawInput, true);

// Check if JSON decode was successful
if (json_last_error() !== JSON_ERROR_NONE) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Invalid JSON data']);
    exit;
}

// Validate input
if (!isset($input['email']) || !isset($input['password'])) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Missing email or password']);
    exit;
}

if (empty($input['email']) || empty($input['password'])) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Email and password cannot be empty']);
    exit;
}

$email = trim($input['email']);
$password = $input['password'];

$conn = getDBConnection();

// Get user by email
$stmt = $conn->prepare("SELECT id, name, email, password FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    http_response_code(401);
    echo json_encode(['success' => false, 'message' => 'Invalid email or password']);
    $stmt->close();
    $conn->close();
    exit;
}

$user = $result->fetch_assoc();
$stmt->close();

// Verify password
if (!password_verify($password, $user['password'])) {
    http_response_code(401);
    echo json_encode(['success' => false, 'message' => 'Invalid email or password']);
    $conn->close();
    exit;
}

// Get user progress
$stmt = $conn->prepare("
    SELECT module_id, completed, completed_at 
    FROM user_progress 
    WHERE user_id = ?
");
$stmt->bind_param("i", $user['id']);
$stmt->execute();
$progressResult = $stmt->get_result();

$progress = [];
while ($row = $progressResult->fetch_assoc()) {
    $progress[$row['module_id']] = [
        'completed' => (bool)$row['completed'],
        'completed_at' => $row['completed_at']
    ];
}
$stmt->close();

// Update last login
$updateStmt = $conn->prepare("UPDATE users SET last_login = NOW() WHERE id = ?");
$updateStmt->bind_param("i", $user['id']);
$updateStmt->execute();
$updateStmt->close();

// Set session
$_SESSION['user_id'] = $user['id'];
$_SESSION['user_email'] = $user['email'];
$_SESSION['user_name'] = $user['name'];

echo json_encode([
    'success' => true,
    'message' => 'Login successful',
    'user' => [
        'id' => $user['id'],
        'name' => $user['name'],
        'email' => $user['email'],
        'progress' => $progress
    ]
]);

$conn->close();
?>