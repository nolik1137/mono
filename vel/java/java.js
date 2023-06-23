document.getElementById("registerLink").addEventListener("click", function(e) {
  e.preventDefault();
  var registrationFormOverlay = document.getElementById("registrationFormOverlay");
  registrationFormOverlay.style.display = "block";
});

document.addEventListener("click", function(e) {
  var registrationFormOverlay = document.getElementById("registrationFormOverlay");
  if (e.target === registrationFormOverlay) {
    registrationFormOverlay.style.display = "none";
  }
});



document.getElementById("loginLink").addEventListener("click", function(event) {
  event.preventDefault();
  document.getElementById("loginFormOverlay").style.display = "block";
});

document.getElementById("loginFormOverlay").addEventListener("click", function(event) {
  if (event.target === this) {
    this.style.display = "none";
  }
});

//ggfg