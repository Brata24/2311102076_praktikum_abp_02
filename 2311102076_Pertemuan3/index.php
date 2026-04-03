<?php
$mahasiswa = [
    [
        "nama" => "Adit",
        "nim" => "23111",
        "tugas" => 80,
        "uts" => 75,
        "uas" => 85
    ],
    [
        "nama" => "Ervan",
        "nim" => "23211",
        "tugas" => 60,
        "uts" => 65,
        "uas" => 70
    ],
    [
        "nama" => "Henwi",
        "nim" => "23122",
        "tugas" => 90,
        "uts" => 85,
        "uas" => 88
    ]
];


function hitungNilaiAkhir($tugas, $uts, $uas)
{
    return ($tugas * 0.3) + ($uts * 0.3) + ($uas * 0.4);
}


function tentukanGrade($nilai)
{
    if ($nilai >= 85) return "A";
    elseif ($nilai >= 75) return "B";
    elseif ($nilai >= 65) return "C";
    elseif ($nilai >= 50) return "D";
    else return "E";
}


$totalNilai = 0;
$nilaiTertinggi = 0;
?>

<!DOCTYPE html>
<html>

<head>
    <title>Data Mahasiswa</title>
    <style>
        table {
            border-collapse: collapse;
            width: 60%;
            margin: 20px auto;
        }

        th,
        td {
            border: 1px solid black;
            padding: 8px;
            text-align: center;
        }

        th {
            background-color: #ddd;
        }
    </style>
</head>

<body>

    <h2 style="text-align:center;">Data Nilai Mahasiswa</h2>

    <table>
        <tr>
            <th>Nama</th>
            <th>NIM</th>
            <th>Nilai Akhir</th>
            <th>Grade</th>
            <th>Status</th>
        </tr>

        <?php
        foreach ($mahasiswa as $mhs) {
            $nilaiAkhir = hitungNilaiAkhir($mhs['tugas'], $mhs['uts'], $mhs['uas']);
            $grade = tentukanGrade($nilaiAkhir);

            $status = ($nilaiAkhir >= 65) ? "Lulus" : "Tidak Lulus";

            $totalNilai += $nilaiAkhir;
            if ($nilaiAkhir > $nilaiTertinggi) {
                $nilaiTertinggi = $nilaiAkhir;
            }

            echo "<tr>
            <td>{$mhs['nama']}</td>
            <td>{$mhs['nim']}</td>
            <td>" . number_format($nilaiAkhir, 2) . "</td>
            <td>$grade</td>
            <td>$status</td>
          </tr>";
        }

        $rataRata = $totalNilai / count($mahasiswa);
        ?>

    </table>

    <div style="text-align:center; margin-top:20px;">
        <p><strong>Rata-rata kelas:</strong> <?= number_format($rataRata, 2); ?></p>
        <p><strong>Nilai tertinggi:</strong> <?= number_format($nilaiTertinggi, 2); ?></p>
    </div>

</body>

</html>