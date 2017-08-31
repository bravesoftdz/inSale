CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;

CREATE TABLE IF NOT EXISTS `mydb`.`empresa` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `razao_social` VARCHAR(255) NOT NULL,
  `nome_fantasia` VARCHAR(255) NULL,
  `cnpj` VARCHAR(14) NOT NULL,
  `status` SMALLINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `cnpj_UNIQUE` (`cnpj` ASC))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`filial` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `empresa_id` INT(11) NOT NULL,
  `razao_social` VARCHAR(255) NOT NULL,
  `nome_fantasia` VARCHAR(255) NULL,
  `cnpj` VARCHAR(14) NULL,
  `status` SMALLINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `fk_filial_empresa1_idx` (`empresa_id` ASC),
  UNIQUE INDEX `cnpj_UNIQUE` (`cnpj` ASC),
  CONSTRAINT `fk_filial_empresa1`
    FOREIGN KEY (`empresa_id`)
    REFERENCES `mydb`.`empresa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`usuario` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `empresa_id` INT(11) NOT NULL,
  `nome` VARCHAR(255) NOT NULL,
  `username` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NULL,
  `status` SMALLINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  INDEX `fk_usuario_empresa1_idx` (`empresa_id` ASC),
  CONSTRAINT `fk_usuario_empresa1`
    FOREIGN KEY (`empresa_id`)
    REFERENCES `mydb`.`empresa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`filial_usuario` (
  `filial_id` INT(11) NOT NULL,
  `usuario_id` INT(11) NOT NULL,
  PRIMARY KEY (`filial_id`, `usuario_id`),
  INDEX `fk_filial_has_usuario_usuario1_idx` (`usuario_id` ASC),
  INDEX `fk_filial_has_usuario_filial1_idx` (`filial_id` ASC),
  CONSTRAINT `fk_filial_has_usuario_filial1`
    FOREIGN KEY (`filial_id`)
    REFERENCES `mydb`.`filial` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_filial_has_usuario_usuario1`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `mydb`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`perfil` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`usuario_perfil` (
  `usuario_id` INT(11) NOT NULL,
  `perfil_id` INT(11) NOT NULL,
  PRIMARY KEY (`usuario_id`, `perfil_id`),
  INDEX `fk_usuario_has_perfil_perfil1_idx` (`perfil_id` ASC),
  INDEX `fk_usuario_has_perfil_usuario1_idx` (`usuario_id` ASC),
  CONSTRAINT `fk_usuario_has_perfil_usuario1`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `mydb`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_has_perfil_perfil1`
    FOREIGN KEY (`perfil_id`)
    REFERENCES `mydb`.`perfil` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`menu` (
  `id` INT(11) NOT NULL,
  `titulo` VARCHAR(100) NOT NULL,
  `link` VARCHAR(255) NULL,
  `parent` INT(11) NULL,
  `sort` INT(4) NULL,
  `icon` VARCHAR(45) NULL,
  `status` SMALLINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`permissao` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `menu_id` INT(11) NOT NULL,
  `nome` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_permissao_menu1_idx` (`menu_id` ASC),
  CONSTRAINT `fk_permissao_menu1`
    FOREIGN KEY (`menu_id`)
    REFERENCES `mydb`.`menu` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`permissao_perfil` (
  `permissao_id` INT(11) NOT NULL,
  `perfil_id` INT(11) NOT NULL,
  PRIMARY KEY (`permissao_id`, `perfil_id`),
  INDEX `fk_permissao_has_perfil_perfil1_idx` (`perfil_id` ASC),
  INDEX `fk_permissao_has_perfil_permissao1_idx` (`permissao_id` ASC),
  CONSTRAINT `fk_permissao_has_perfil_permissao1`
    FOREIGN KEY (`permissao_id`)
    REFERENCES `mydb`.`permissao` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_permissao_has_perfil_perfil1`
    FOREIGN KEY (`perfil_id`)
    REFERENCES `mydb`.`perfil` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`log_type` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`log` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `log_type_id` INT(11) NOT NULL,
  `descricao` VARCHAR(255) NOT NULL,
  `data_cadastro` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_log_log_type_idx` (`log_type_id` ASC),
  CONSTRAINT `fk_log_log_type`
    FOREIGN KEY (`log_type_id`)
    REFERENCES `mydb`.`log_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`produto` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(255) NOT NULL,
  `codigo_de_barras` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `mydb`.`estoque` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `filial_id` INT(11) NOT NULL,
  `produto_id` INT(11) NOT NULL,
  `quantidade` INT(5) NULL,
  `peso` FLOAT NULL,
  `valor` FLOAT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_estoque_produto1_idx` (`produto_id` ASC),
  INDEX `fk_estoque_filial1_idx` (`filial_id` ASC),
  CONSTRAINT `fk_estoque_produto1`
    FOREIGN KEY (`produto_id`)
    REFERENCES `mydb`.`produto` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_estoque_filial1`
    FOREIGN KEY (`filial_id`)
    REFERENCES `mydb`.`filial` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`entrada` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `estoque_id` INT(11) NOT NULL,
  `valor` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_entrada_estoque1_idx` (`estoque_id` ASC),
  CONSTRAINT `fk_entrada_estoque1`
    FOREIGN KEY (`estoque_id`)
    REFERENCES `mydb`.`estoque` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`saida` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `estoque_id` INT(11) NOT NULL,
  `valor` FLOAT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_saida_estoque1_idx` (`estoque_id` ASC),
  CONSTRAINT `fk_saida_estoque1`
    FOREIGN KEY (`estoque_id`)
    REFERENCES `mydb`.`estoque` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;