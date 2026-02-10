<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\V1\UserController;
use App\Http\Controllers\V1\NewsController;


Route::apiResource('users', UserController::class);
Route::apiResource('news', NewsController::class);

Route::get("/ping", function () {
    return response()->json(["ok" => true]);
});


