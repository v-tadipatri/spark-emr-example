import Dependencies._

ThisBuild / organization := "com.example"
ThisBuild / scalaVersion := "2.12.17"
addCompilerPlugin("org.scalameta" % "semanticdb-scalac" % "4.7.8" cross CrossVersion.full)
val isLocal = sys.env.get("LOCAL_MODE").contains("1")
val sparkDeps =if (isLocal) {
  println(s"local mode = ${isLocal}")
  //In local mode (IDE), we want the spark libraries
  //set LOCAL_MODE as env variable in your IDE
  Seq(
    "org.apache.spark" %% "spark-core" % "3.5.1", //% Provided,
    "org.apache.spark" %% "spark-sql" % "3.5.1" //% Provided
  )
} else {
  //when building a jar to deploy, do not include spark
  //turn off LOCAL_MODE when running sbt assembly!
  Seq(
    "org.apache.spark" %% "spark-core" % "3.5.1" % Provided,
    "org.apache.spark" %% "spark-sql" % "3.5.1" % Provided
  )
}

lazy val root = (project in file(".")).
  settings(
    name := "spark-emr-example",
    scalacOptions ++= Seq(
      "-feature",
      "-deprecation",
      "-unchecked",
      "-language:postfixOps",
      "-language:higherKinds", // HKT required for Monads and other HKT types
      "-Yrangepos", // required for semantic db
    ),
    libraryDependencies ++= Dependencies.core ++ Dependencies.scalaTest ++ sparkDeps,
    Compile / discoveredMainClasses := Seq(), // ignore discovered main classes
    Compile / mainClass := Some("com.example.SparkWordCountApp"),
    assembly / mainClass := Some("com.example.SparkWordCountApp"),
    assembly / assemblyJarName := "spark-emr-example.jar",
    assembly / test := {},
    assembly / assemblyMergeStrategy := {
      case PathList("META-INF", xs @ _*) => MergeStrategy.discard
      case "application.conf"            => MergeStrategy.concat
      case x =>
        val oldStrategy = (assembly / assemblyMergeStrategy).value
        oldStrategy(x)
    }
  )
