FROM openjdk:8
ADD  webapp/target/webapp.war webapp.war
ENTRYPOINT ["java", "-jar", "webapp.war"]
