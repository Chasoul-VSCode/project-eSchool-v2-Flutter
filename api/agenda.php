<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

$host = "localhost";
$user = "chasoul"; 
$pass = "131122"; 
$db   = "solev"; 
$connection = new mysqli($host, $user, $pass, $db);

if ($connection->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $connection->connect_error]));
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        handleGet($connection);
        break;
    case 'POST':
        handlePost($connection);
        break;
    case 'PUT':
        handlePut($connection);
        break;
    case 'DELETE':
        handleDelete($connection);
        break;
    default:
        echo json_encode(["error" => "Invalid method"]);
        break;
}

$connection->close();

function handleGet($connection) {
    if (isset($_GET['kd_agenda'])) {
        $kd_agenda = $connection->real_escape_string($_GET['kd_agenda']);
        $sql = "SELECT * FROM agenda WHERE kd_agenda = ?";
        $stmt = $connection->prepare($sql);
        if (!$stmt) {
            echo json_encode(["error" => "Prepare failed: " . $connection->error]);
            return;
        }
        $stmt->bind_param("s", $kd_agenda);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result && $result->num_rows > 0) {
            $data = $result->fetch_assoc();
            echo json_encode($data);
        } else {
            echo json_encode(["error" => "No data found for the given kd_agenda"]);
        }
        $stmt->close();
    } else {
        $sql = "SELECT * FROM agenda";
        $result = $connection->query($sql);
        if ($result && $result->num_rows > 0) {
            $data = $result->fetch_all(MYSQLI_ASSOC);
            echo json_encode($data);
        } else {
            echo json_encode(["error" => "No data found"]);
        }
    }
    
    // Add error checking
    if (!$result) {
        echo json_encode(["error" => "Query failed: " . $connection->error]);
    }
}

function handlePost($connection) {
    $input = json_decode(file_get_contents('php://input'), true);
    
    // Log incoming data for debugging
    logIncomingData($input);
    
    // Validate input
    $required_fields = ['judul_agenda', 'isi_agenda', 'tgl_agenda', 'tgl_post_agenda', 'status_agenda', 'kd_petugas'];
    foreach ($required_fields as $field) {
        if (!isset($input[$field]) || empty($input[$field])) {
            $error = "Missing required field: $field";
            logError($error);
            echo json_encode(["error" => $error]);
            return;
        }
    }
    
    $judul_agenda = $input['judul_agenda'];
    $isi_agenda = $input['isi_agenda'];
    $tgl_agenda = $input['tgl_agenda'];
    $tgl_post_agenda = $input['tgl_post_agenda'];
    $status_agenda = $input['status_agenda'];
    $kd_petugas = $input['kd_petugas'];

    $sql = "INSERT INTO agenda (judul_agenda, isi_agenda, tgl_agenda, tgl_post_agenda, status_agenda, kd_petugas)
            VALUES (?, ?, ?, ?, ?, ?)";
    
    $stmt = $connection->prepare($sql);
    if (!$stmt) {
        $error = "Prepare failed: " . $connection->error;
        logError($error);
        echo json_encode(["error" => $error]);
        return;
    }

    $stmt->bind_param("ssssss", $judul_agenda, $isi_agenda, $tgl_agenda, $tgl_post_agenda, $status_agenda, $kd_petugas);
    
    if ($stmt->execute()) {
        echo json_encode(["message" => "Data added successfully", "kd_agenda" => $connection->insert_id]);
    } else {
        $error = "Failed to add data: " . $stmt->error;
        logError($error);
        echo json_encode(["error" => $error]);
    }
    
    $stmt->close();
}

function handlePut($connection) {
    $input = json_decode(file_get_contents('php://input'), true);
    
    // Validate input
    if (!isset($input['kd_agenda']) || empty($input['kd_agenda'])) {
        echo json_encode(["error" => "Missing required field: kd_agenda"]);
        return;
    }
    
    $kd_agenda = $input['kd_agenda'];
    
    $fields = ['judul_agenda', 'isi_agenda', 'tgl_agenda', 'tgl_post_agenda', 'status_agenda', 'kd_petugas'];
    $updates = [];
    $types = "";
    $values = [];
    
    foreach ($fields as $field) {
        if (isset($input[$field]) && !empty($input[$field])) {
            $updates[] = "$field = ?";
            $types .= "s";
            $values[] = $input[$field];
        }
    }
    
    if (empty($updates)) {
        echo json_encode(["error" => "No fields to update"]);
        return;
    }
    
    $sql = "UPDATE agenda SET " . implode(", ", $updates) . " WHERE kd_agenda = ?";
    $types .= "s";
    $values[] = $kd_agenda;
    
    $stmt = $connection->prepare($sql);
    if (!$stmt) {
        echo json_encode(["error" => "Prepare failed: " . $connection->error]);
        return;
    }

    $stmt->bind_param($types, ...$values);
    
    if ($stmt->execute()) {
        echo json_encode(["message" => "Data updated successfully"]);
    } else {
        echo json_encode(["error" => "Failed to update data: " . $stmt->error]);
    }
    
    $stmt->close();
}

function handleDelete($connection) {
    if (isset($_GET['kd_agenda'])) {
        $kd_agenda = $_GET['kd_agenda'];
        $sql = "DELETE FROM agenda WHERE kd_agenda = ?";
        $stmt = $connection->prepare($sql);
        if (!$stmt) {
            echo json_encode(["error" => "Prepare failed: " . $connection->error]);
            return;
        }
        $stmt->bind_param("s", $kd_agenda);
        if ($stmt->execute()) {
            echo json_encode(["message" => "Data deleted successfully"]);
        } else {
            echo json_encode(["error" => "Failed to delete data: " . $stmt->error]);
        }
        $stmt->close();
    } else {
        echo json_encode(["error" => "kd_agenda not found"]);
    }
}

// Log errors to a file
function logError($message) {
    $logFile = 'error_log.txt';
    $timestamp = date('Y-m-d H:i:s');
    $logMessage = "[$timestamp] $message\n";
    file_put_contents($logFile, $logMessage, FILE_APPEND);
}

// Debug function to log incoming data
function logIncomingData($data) {
    $logFile = 'incoming_data_log.txt';
    $timestamp = date('Y-m-d H:i:s');
    $logMessage = "[$timestamp] Incoming Data: " . print_r($data, true) . "\n";
    file_put_contents($logFile, $logMessage, FILE_APPEND);
}

// Close the PHP tag only if it's the end of the file
?>
