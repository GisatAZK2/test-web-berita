console.log("Script loaded successfully!");

let imagePath = "/storage/image.jpeg";

// ambil elemen gambar
const gambar = document.getElementById("gambar");

// set src gambar
gambar.src = imagePath;

// kalau gambar diklik → toggle mutar
gambar.addEventListener("click", function () {
  gambar.classList.toggle("spin");
});
