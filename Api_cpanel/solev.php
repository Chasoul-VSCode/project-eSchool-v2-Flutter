<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

$host = "localhost";
$user = "praktikum_solev";
$password = "solev2024";
$dbname = "praktikum_kelompok_solev";
$conn = mysqli_connect($host, $user, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        handleGet($conn);
        break;
    case 'POST':
        handlePost($conn);
        break;
    case 'PUT':
        handlePut($conn);
        break;
    case 'DELETE':
        handleDelete($conn);
        break;
    default:
        echo json_encode(["error" => "Invalid method"]);
        break;
}

$conn->close();

function handleGet($conn) {
    if (isset($_GET['kd_info'])) {
        $kd_info = $conn->real_escape_string($_GET['kd_info']);
        $sql = "SELECT * FROM informasi WHERE kd_info = '$kd_info'";
        $result = $conn->query($sql);
        if ($result && $result->num_rows > 0) {
            $data = $result->fetch_assoc();
            echo json_encode($data);
        } else {
            echo json_encode(["error" => "No data found for the given kd_info"]);
        }
    } else {
        $sql = "SELECT * FROM informasi";
        $result = $conn->query($sql);
        if ($result && $result->num_rows > 0) {
            $data = $result->fetch_all(MYSQLI_ASSOC);
            echo json_encode($data);
        } else {
            echo json_encode(["error" => "No data found"]);
        }
    }
    
    if (!$result) {
        echo json_encode(["error" => "Query failed: " . $conn->error]);
    }
}

function handlePost($conn) {
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($input['judul_info']) || !isset($input['isi_info'])) {
        echo json_encode(["error" => "Missing required fields"]);
        return;
    }
    
    $judul_info = $conn->real_escape_string($input['judul_info']);
    $isi_info = $conn->real_escape_string($input['isi_info']);
    $tgl_post_info = isset($input['tgl_post_info']) ? $conn->real_escape_string($input['tgl_post_info']) : date('Y-m-d H:i:s');
    $status_info = isset($input['status_info']) ? $conn->real_escape_string($input['status_info']) : 'active';
    $kd_petugas = isset($input['kd_petugas']) ? $conn->real_escape_string($input['kd_petugas']) : '1';

    $sql = "INSERT INTO informasi (judul_info, isi_info, tgl_post_info, status_info, kd_petugas)
            VALUES ('$judul_info', '$isi_info', '$tgl_post_info', '$status_info', '$kd_petugas')";
    
    if ($conn->query($sql)) {
        echo json_encode(["message" => "Data added successfully", "id" => $conn->insert_id]);
    } else {
        echo json_encode(["error" => "Failed to add data: " . $conn->error]);
    }
}

function handlePut($conn) {
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($input['kd_info'])) {
        echo json_encode(["error" => "Missing kd_info"]);
        return;
    }
    
    $kd_info = $conn->real_escape_string($input['kd_info']);
    $updates = [];
    
    $fields = ['judul_info', 'isi_info', 'tgl_post_info', 'status_info', 'kd_petugas'];
    foreach ($fields as $field) {
        if (isset($input[$field])) {
            $updates[] = "$field = '" . $conn->real_escape_string($input[$field]) . "'";
        }
    }
    
    if (empty($updates)) {
        echo json_encode(["error" => "No fields to update"]);
        return;
    }

    $sql = "UPDATE informasi SET " . implode(', ', $updates) . " WHERE kd_info = '$kd_info'";
    
    if ($conn->query($sql)) {
        echo json_encode(["message" => "Data updated successfully"]);
    } else {
        echo json_encode(["error" => "Failed to update data: " . $conn->error]);
    }
}

function handleDelete($conn) {
    if (isset($_GET['kd_info'])) {
        $kd_info = $conn->real_escape_string($_GET['kd_info']);
        $sql = "DELETE FROM informasi WHERE kd_info = '$kd_info'";
        if ($conn->query($sql)) {
            if ($conn->affected_rows > 0) {
                echo json_encode(["message" => "Data deleted successfully"]);
            } else {
                echo json_encode(["error" => "No data found with the given kd_info"]);
            }
        } else {
            echo json_encode(["error" => "Failed to delete data: " . $conn->error]);
        }
    } else {
        echo json_encode(["error" => "kd_info not provided"]);
    }
}
?>
