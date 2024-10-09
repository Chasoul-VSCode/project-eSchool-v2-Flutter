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
    if (isset($_GET['kd_galery'])) {
        $kd_galery = $connection->real_escape_string($_GET['kd_galery']);
        $sql = "SELECT * FROM galery WHERE kd_galery = '$kd_galery'";
        $result = $connection->query($sql);
        if ($result && $result->num_rows > 0) {
            $data = $result->fetch_assoc();
            echo json_encode($data);
        } else {
            echo json_encode(["error" => "No data found for the given kd_galery"]);
        }
    } else {
        $sql = "SELECT * FROM galery";
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
    $judul_galery = $connection->real_escape_string($input['judul_galery']);
    $isi_galery = $connection->real_escape_string($input['isi_galery']);
    $tgl_post_galery = $connection->real_escape_string($input['tgl_post_galery']);
    $status_galery = $connection->real_escape_string($input['status_galery']);
    $kd_petugas = $connection->real_escape_string($input['kd_petugas']);

    $sql = "INSERT INTO galery (judul_galery, isi_galery, tgl_post_galery, status_galery, kd_petugas)
            VALUES ('$judul_galery', '$isi_galery', '$tgl_post_galery', '$status_galery', '$kd_petugas')";
    
    if ($connection->query($sql)) {
        echo json_encode(["message" => "Data added successfully"]);
    } else {
        echo json_encode(["error" => "Failed to add data: " . $connection->error]);
    }
}

function handlePut($connection) {
    $input = json_decode(file_get_contents('php://input'), true);
    $kd_galery = $connection->real_escape_string($input['kd_galery']);
    $judul_galery = $connection->real_escape_string($input['judul_galery']);
    $isi_galery = $connection->real_escape_string($input['isi_galery']);
    $tgl_post_galery = $connection->real_escape_string($input['tgl_post_galery']);
    $status_galery = $connection->real_escape_string($input['status_galery']);
    $kd_petugas = $connection->real_escape_string($input['kd_petugas']);

    $sql = "UPDATE galery SET
            judul_galery = '$judul_galery',
            isi_galery = '$isi_galery',
            tgl_post_galery = '$tgl_post_galery',
            status_galery = '$status_galery',
            kd_petugas = '$kd_petugas'
            WHERE kd_galery = '$kd_galery'";
    
    if ($connection->query($sql)) {
        echo json_encode(["message" => "Data updated successfully"]);
    } else {
        echo json_encode(["error" => "Failed to update data: " . $connection->error]);
    }
}

function handleDelete($connection) {
    if (isset($_GET['kd_galery'])) {
        $kd_galery = $connection->real_escape_string($_GET['kd_galery']);
        $sql = "DELETE FROM galery WHERE kd_galery = '$kd_galery'";
        if ($connection->query($sql)) {
            echo json_encode(["message" => "Data deleted successfully"]);
        } else {
            echo json_encode(["error" => "Failed to delete data: " . $connection->error]);
        }
    } else {
        echo json_encode(["error" => "kd_galery not found"]);
    }
}
?>
