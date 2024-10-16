<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

$host = "localhost";
$user = "chasoulu_schoolapp"; 
$pass = "Shacia1858"; 
$db   = "chasoulu_school_app";
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
    $kd_info = isset($_GET['kd_info']) ? $connection->real_escape_string($_GET['kd_info']) : null;
    $sql = $kd_info ? "SELECT * FROM informasi WHERE kd_info = '$kd_info'" : "SELECT * FROM informasi";
    
    $result = $connection->query($sql);
    
    if ($result) {
        $data = $kd_info ? $result->fetch_assoc() : $result->fetch_all(MYSQLI_ASSOC);
        echo json_encode($data ?: ["error" => "No data found"]);
    } else {
        echo json_encode(["error" => "Query failed: " . $connection->error]);
    }
}

function handlePost($connection) {
    $input = json_decode(file_get_contents('php://input'), true);
    $requiredFields = ['judul_info', 'isi_info', 'tgl_post_info', 'status_info', 'kd_petugas'];

    foreach ($requiredFields as $field) {
        if (!isset($input[$field])) {
            echo json_encode(["error" => "Missing field: $field"]);
            return;
        }
    }

    $stmt = $connection->prepare("INSERT INTO informasi (judul_info, isi_info, tgl_post_info, status_info, kd_petugas) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssi", $input['judul_info'], $input['isi_info'], $input['tgl_post_info'], $input['status_info'], $input['kd_petugas']);

    if ($stmt->execute()) {
        echo json_encode(["message" => "Data added successfully"]);
    } else {
        echo json_encode(["error" => "Failed to add data: " . $stmt->error]);
    }

    $stmt->close();
}

function handlePut($connection) {
    $input = json_decode(file_get_contents('php://input'), true);
    $requiredFields = ['kd_info', 'judul_info', 'isi_info'];

    // Check for required fields
    foreach ($requiredFields as $field) {
        if (!isset($input[$field])) {
            echo json_encode(["error" => "Missing field: $field"]);
            return;
        }
    }

    // Debugging: log input values
    error_log("Input data: " . print_r($input, true));

    // Prepare the SQL statement for updating only the specified fields
    $stmt = $connection->prepare("UPDATE informasi SET judul_info = ?, isi_info = ? WHERE kd_info = ?");

    // Check if the statement was prepared successfully
    if (!$stmt) {
        echo json_encode(["error" => "Statement preparation failed: " . $connection->error]);
        return;
    }

    // Bind parameters
    $stmt->bind_param("ssi", $input['judul_info'], $input['isi_info'], $input['kd_info']);

    // Execute the query
    if ($stmt->execute()) {
        // Check how many rows were affected
        if ($stmt->affected_rows > 0) {
            echo json_encode(["message" => "Data updated successfully"]);
        } else {
            echo json_encode(["error" => "No records updated. Ensure kd_info exists or values are the same."]);
        }
    } else {
        echo json_encode(["error" => "Failed to update data: " . $stmt->error]);
    }

    // Close the statement
    $stmt->close();
}


function handleDelete($connection) {
    if (isset($_GET['kd_info'])) {
        $kd_info = $connection->real_escape_string($_GET['kd_info']);
        $stmt = $connection->prepare("DELETE FROM informasi WHERE kd_info = ?");
        $stmt->bind_param("s", $kd_info);

        if ($stmt->execute()) {
            if ($stmt->affected_rows > 0) {
                echo json_encode(["message" => "Data deleted successfully"]);
            } else {
                echo json_encode(["error" => "No records deleted, check if kd_info exists"]);
            }
        } else {
            echo json_encode(["error" => "Failed to delete data: " . $stmt->error]);
        }

        $stmt->close();
    } else {
        echo json_encode(["error" => "kd_info not found"]);
    }
}
?>
