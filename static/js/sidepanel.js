function openNav(){
    document.getElementById("mySidepanel").style.width = "25%";
}

function closeNav(){
    document.getElementById("mySidepanel").style.width = "0";
}

function openDropdownPracticante(){
    document.getElementById("dropdown_practicantes").style.display = "flex";
    document.getElementById("dropdownBtn_practicantes").innerHTML = "&#9650;"
    document.getElementById("dropdownBtn_practicantes").onclick = closeDropdownPracticante;
}

function closeDropdownPracticante(){
    document.getElementById("dropdown_practicantes").style.display = "none";
    document.getElementById("dropdownBtn_practicantes").innerHTML = "&#9660;"
    document.getElementById("dropdownBtn_practicantes").onclick = openDropdownPracticante;
}

function openDropdownPracticas(){
    document.getElementById("dropdown_practicas").style.display = "flex";
    document.getElementById("dropdownBtn_practicas").innerHTML = "&#9650;"
    document.getElementById("dropdownBtn_practicas").onclick = closeDropdownPracticas;
}

function closeDropdownPracticas(){
    document.getElementById("dropdown_practicas").style.display = "none";
    document.getElementById("dropdownBtn_practicas").innerHTML = "&#9660;"
    document.getElementById("dropdownBtn_practicas").onclick = openDropdownPracticas;
}