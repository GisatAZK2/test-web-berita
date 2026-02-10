<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="css/about.css">
</head>
<body>
    <div>
    <h2>Ini Aku</h2>


    @if (Route::has('index'))
    <div class="container">
        <a class="btn" href="{{ route('index') }}">Home Page</a>
      
    </div>
       
    @endif

    <img class="img" id="gambar">
</div>
<script src="js/about.js"></script>
</body>
</html>