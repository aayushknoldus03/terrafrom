output "uppername" {
  value = "${upper(var.user[0])}"
}
output "firstname" {
  value = "${join("--->",var.user)}"
}
output "maxvalue" {
  value = "${max(5,6,9,2,1)}"
}
output "concat" {
  value = "${concat(["hello"],["how"],["Are"],["you"])}"
}
output "conca1t" {
  value = "${concat(var.user,var.age)}"
}
output "hamcking" {
 value = "${base64decode("SGVsbG8gV29ybGQ=")}"
}
output "encodethis" {
  value = "${base64encode("Hello, my name is Aayush")}"
}
output "timestamp" {
  value = "${plantimestamp()}"
}
output "decode" {
  value = "${base64decode(filebase64("./secret.sh.gpg"))}"
}