TRUNCATE TABLE users RESTART IDENTITY;

INSERT INTO users (email, password) VALUES ('duck@makers.com', 'quack!');
INSERT INTO users (email, password)
  VALUES ('duck2@makers.com', '$2a$12$qmO3XbZHMXhymqZBstr48O0rW8ubyqAITgm9T.cIoQrk0CMEEfECm');
INSERT INTO users (email, password)
  VALUES ('homer@simpsons.com', '$2a$12$GKyE/JG3VsUfVeaPzfoNu.4U2DLkXo9uPbq1/K2MohAgAC2Qw4sTm');
