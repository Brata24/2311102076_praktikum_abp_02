<?php

header('Content-Type: application/json');

$data = [
    'nama' => 'Adit',
    'pekerjaan' => 'Dosen',
    'lokasi' => 'Purwokerto',
];

echo json_encode($data);