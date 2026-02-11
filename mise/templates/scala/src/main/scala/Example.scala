package com.example

case class User(name: String, age: Int):
  def greet: String = s"Hello, I'm $name"

  def isAdult: Boolean = age >= 18

object Example:
  def main(args: Array[String]): Unit =
    val users = List(
      User("Alice", 30),
      User("Bob", 17),
      User("Charlie", 25)
    )

    val adults = users.filter(_.isAdult)
    adults.foreach(u => println(u.greet))

  def findUser(users: List[User], name: String): Option[User] =
    users.find(_.name == name)

  def averageAge(users: List[User]): Double =
    if users.isEmpty then 0.0
    else users.map(_.age).sum.toDouble / users.size
