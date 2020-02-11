function ErrorNotBetween($number) {
    if($number -in 1..5 -eq $false) {
        Write-Error -Message "El numero no se encuentra entre el uno y el cinco" -ErrorAction Stop
    }
}

[Int32]$num1 = Read-Host -Prompt "Ponga el primer número (entre el 1 y 5)"
ErrorNotBetween $num1

[Int32]$num2 = Read-Host -Prompt "Ponga el segundo número (entre el 1 y 5)"
ErrorNotBetween $num2

if($num1 -gt $num2) {
    $z = $num1
    $num1 = $num2
    $num2 = $z
}

Write-Host "La sucesion aritmetico geometrica para los siguientes 6 elementos es;"

Write-Host -NoNewline "$num1, $num2"

[int32]$sum = $num1 + $num2

for($i=1;$i-lt 6;$i++) {
    [Int32]$n = $num1 * $num2
    Write-Host -NoNewline ", $n"
    $num1 = $num2
    $num2 = $n
    $sum += $n
}
Write-Host " y su suma total vale $sum" 
