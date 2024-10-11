<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

$host = "localhost";
$user = "chasoulu_solev";
$password = "Shacia1858";
$dbname = "chasoulu_solev";
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
    if (isset($_GET['kd_galery'])) {
        $kd_galery = $conn->real_escape_string($_GET['kd_galery']);
        $sql = "SELECT * FROM galery WHERE kd_galery = ?";
        $stmt = $conn->prepare($sql);

        if (!$stmt) {
            echo json_encode(["error" => "Prepare failed: " . $conn->error]);
            return;
        }

        $stmt->bind_param("s", $kd_galery);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result && $result->num_rows > 0) {
            $data = $result->fetch_assoc();
            echo json_encode($data);
        } else {
            echo json_encode(["error" => "No data found for the given kd_galery"]);
        }

        $stmt->close();
    } else {
        $sql = "SELECT * FROM galery";
        $result = $conn->query($sql);
        if ($result && $result->num_rows > 0) {
            $data = $result->fetch_all(MYSQLI_ASSOC);
            echo json_encode($data);
        } else {
            echo json_encode(["error" => "No data found"]);
        }
    }
}

function handlePost($conn) {
    $judul_galery = $conn->real_escape_string($_POST['judul_galery']);
    $tgl_post_galery = $conn->real_escape_string($_POST['tgl_post_galery']);
    $status_galery = $conn->real_escape_string($_POST['status_galery']);
    $kd_petugas = $conn->real_escape_string($_POST['kd_petugas']);

    $isi_galery = '';
    if (isset($_FILES['image']) && $_FILES['image']['error'] == UPLOAD_ERR_OK) {
        $image = $_FILES['image'];
        $image_name = time() . '_' . basename($image['name']);
        $target_path = __DIR__ . '/images/' . $image_name;

        if (move_uploaded_file($image['tmp_name'], $target_path)) {
            $isi_galery = 'images/' . $image_name; // Store relative path
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to upload image"]);
            return;
        }
    }

    $sql = "INSERT INTO galery (judul_galery, isi_galery, tgl_post_galery, status_galery, kd_petugas)
            VALUES (?, ?, ?, ?, ?)";
    
    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        echo json_encode(["status" => "error", "message" => "Prepare failed: " . $conn->error]);
        return;
    }

    $stmt->bind_param("sssss", $judul_galery, $isi_galery, $tgl_post_galery, $status_galery, $kd_petugas);
    
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Data added successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to add data: " . $stmt->error]);
    }
    
    $stmt->close();
}

function handlePut($conn) {
    parse_str(file_get_contents("php://input"), $_PUT);
    
    if (!isset($_PUT['kd_galery'])) {
        echo json_encode(["error" => "Missing kd_galery"]);
        return;
    }

    $kd_galery = $conn->real_escape_string($_PUT['kd_galery']);
    $judul_galery = $conn->real_escape_string($_PUT['judul_galery']);
    $tgl_post_galery = $conn->real_escape_string($_PUT['tgl_post_galery']);
    $status_galery = $conn->real_escape_string($_PUT['status_galery']);
    $kd_petugas = $conn->real_escape_string($_PUT['kd_petugas']);

    // Get existing image if no new image is uploaded
    $isi_galery = '';
    if (isset($_FILES['image']) && $_FILES['image']['error'] == UPLOAD_ERR_OK) {
        $image = $_FILES['image'];
        $image_name = time() . '_' . basename($image['name']);
        $target_path = __DIR__ . '/images/' . $image_name;

        if (move_uploaded_file($image['tmp_name'], $target_path)) {
            $isi_galery = 'images/' . $image_name; // Store relative path
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to upload image"]);
            return;
        }
    } else {
        // If no new image, retrieve the existing one
        $sql = "SELECT isi_galery FROM galery WHERE kd_galery = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $kd_galery);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result && $result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $isi_galery = $row['isi_galery'];
        } else {
            echo json_encode(["error" => "kd_galery not found"]);
            return;
        }
        $stmt->close();
    }

    $sql = "UPDATE galery SET
            judul_galery = ?, isi_galery = ?, tgl_post_galery = ?, status_galery = ?, kd_petugas = ?
            WHERE kd_galery = ?";
    
    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        echo json_encode(["error" => "Prepare failed: " . $conn->error]);
        return;
    }

    $stmt->bind_param("ssssss", $judul_galery, $isi_galery, $tgl_post_galery, $status_galery, $kd_petugas, $kd_galery);
    
    if ($stmt->execute()) {
        echo json_encode(["message" => "Data updated successfully"]);
    } else {
        echo json_encode(["error" => "Failed to update data: " . $stmt->error]);
    }
    
    $stmt->close();
}

function handleDelete($conn) {
    if (isset($_GET['kd_galery'])) {
        $kd_galery = $conn->real_escape_string($_GET['kd_galery']);
        
        // Check if the record exists before deleting
        $sql = "SELECT * FROM galery WHERE kd_galery = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $kd_galery);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result && $result->num_rows > 0) {
            $stmt->close();

            $sql = "DELETE FROM galery WHERE kd_galery = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("s", $kd_galery);
            if ($stmt->execute()) {
                echo json_encode(["message" => "Data deleted successfully"]);
            } else {
                echo json_encode(["error" => "Failed to delete data: " . $stmt->error]);
            }
        } else {
            echo json_encode(["error" => "kd_galery not found"]);
        }

        $stmt->close();
    } else {
        echo json_encode(["error" => "kd_galery not found"]);
    }
}
?>
