Attribute VB_Name = "round5x"
Private Function rd5x(X As Double, mm As Integer) As Double
If mm < 0 Then
    rd5x = 0
    Exit Function
End If
Dim rval, remain As Integer
tval = X * 10 ^ (mm + 1)
rval = Int(X * 10 ^ mm)
remain = Int(tval) Mod 10
If remain = 5 Then
    Dim ary() As String
    ary = Split(tval, ".")
    Dim a, b As Integer
    a = b = Int(tval)
    If UBound(ary) > 0 Then
        Dim c As Integer
        c = Len(ary(1))
        a = tval * 10 ^ c
        b = b * 10 ^ c
    End If
    If a = b Then
        If (rval Mod 2) = 1 Then
            rval = rval + 1
        End If
    Else
        rval = rval + 1
    End If
ElseIf remain > 5 Then
    rval = rval + 1
End If
rd5x = rval / 10 ^ mm
End Function


