<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/abc', function () {
    return response()->json([
        'name' => 'John Doe',
        'age' => 30,
    ]);
});
