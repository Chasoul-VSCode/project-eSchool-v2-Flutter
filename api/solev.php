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
    if (isset($_GET['kd_info'])) {
        $kd_info = $connection->real_escape_string($_GET['kd_info']);
        $sql = "SELECT * FROM informasi WHERE kd_info = '$kd_info'";
        $result = $connection->query($sql);
        if ($result && $result->num_rows > 0) {
            $data = $result->fetch_assoc();
            echo json_encode($data);
        } else {
            echo json_encode(["error" => "No data found for the given kd_info"]);
        }
    } else {
        $sql = "SELECT * FROM informasi";
        $result = $connection->query($sql);
        if ($result && $result->num_rows > 0) {
            $data = $result->fetch_all(MYSQLI_ASSOC);
            echo json_encode($data);
        } else {
            echo json_encode(["error" => "No data found"]);
        }
    }
    
    if (!$result) {
        echo json_encode(["error" => "Query failed: " . $connection->error]);
    }
}

function handlePost($connection) {
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($input['judul_info']) || !isset($input['isi_info'])) {
        echo json_encode(["error" => "Missing required fields"]);
        return;
    }
    
    $judul_info = $connection->real_escape_string($input['judul_info']);
    $isi_info = $connection->real_escape_string($input['isi_info']);
    $tgl_post_info = isset($input['tgl_post_info']) ? $connection->real_escape_string($input['tgl_post_info']) : date('Y-m-d H:i:s');
    $status_info = isset($input['status_info']) ? $connection->real_escape_string($input['status_info']) : 'active';
    $kd_petugas = isset($input['kd_petugas']) ? $connection->real_escape_string($input['kd_petugas']) : '1';

    $sql = "INSERT INTO informasi (judul_info, isi_info, tgl_post_info, status_info, kd_petugas)
            VALUES ('$judul_info', '$isi_info', '$tgl_post_info', '$status_info', '$kd_petugas')";
    
    if ($connection->query($sql)) {
        echo json_encode(["message" => "Data added successfully", "id" => $connection->insert_id]);
    } else {
        echo json_encode(["error" => "Failed to add data: " . $connection->error]);
    }
}

function handlePut($connection) {
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($input['kd_info'])) {
        echo json_encode(["error" => "Missing kd_info"]);
        return;
    }
    
    $kd_info = $connection->real_escape_string($input['kd_info']);
    $updates = [];
    
    $fields = ['judul_info', 'isi_info', 'tgl_post_info', 'status_info', 'kd_petugas'];
    foreach ($fields as $field) {
        if (isset($input[$field])) {
            $updates[] = "$field = '" . $connection->real_escape_string($input[$field]) . "'";
        }
    }
    
    if (empty($updates)) {
        echo json_encode(["error" => "No fields to update"]);
        return;
    }

    $sql = "UPDATE informasi SET " . implode(', ', $updates) . " WHERE kd_info = '$kd_info'";
    
    if ($connection->query($sql)) {
        echo json_encode(["message" => "Data updated successfully"]);
    } else {
        echo json_encode(["error" => "Failed to update data: " . $connection->error]);
    }
}

function handleDelete($connection) {
    if (isset($_GET['kd_info'])) {
        $kd_info = $connection->real_escape_string($_GET['kd_info']);
        $sql = "DELETE FROM informasi WHERE kd_info = '$kd_info'";
        if ($connection->query($sql)) {
            if ($connection->affected_rows > 0) {
                echo json_encode(["message" => "Data deleted successfully"]);
            } else {
                echo json_encode(["error" => "No data found with the given kd_info"]);
            }
        } else {
            echo json_encode(["error" => "Failed to delete data: " . $connection->error]);
        }
    } else {
        echo json_encode(["error" => "kd_info not provided"]);
    }
}
?>