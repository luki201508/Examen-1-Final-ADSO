[Int32]$num1 = Read-Host -Prompt "Ponga el primer número (entre el 1 y 5)"

[Int32]$num2 = Read-Host -Prompt "Ponga el segundo número (entre el 1 y 5)"

Write-Host "La sucesion aritmetico geometrica para los siguientes 6 elementos es;"

Write-Host -NoNewline "$num1, $num2"

if($num1 -gt $num2) {
    $z = $num1
    $num1 = $num2
    $num2 = $z
}

[int32]$sum = $num1 + $num2

for($i=1;$i-lt 6;$i++) {
    [Int32]$n = $num1 * $num2
    Write-Host -NoNewline ", $n"
    $num1 = $num2
    $num2 = $n
    $sum += $n
}

Write-Host " y su suma total vale $sum" 
