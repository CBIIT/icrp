<?php

namespace Drupal\db_admin\Controller;
use PDO;

class NonPartners {

  public static function add(PDO $pdo, array $parameters): bool {
    return PDOBuilder::createPreparedStatement(
      $pdo,
      "EXECUTE AddNonPartner
        @Name = :name,
        @Description = :description,
        @SponsorCode = :sponsorCode,
        @Email = :email,
        @Country = :country,
        @Website = :website,
        @LogoFile = :logoFile,
        @Note = :note,
        @Longitude = :longitude,
        @Latitude = :latitude,
        @EstimatedInv = :estimatedInvestment,
        @DoNotContact = :doNotContact,
        @CancerOnly = :cancerOnly,
        @ResearchFunder = :researchFunder,
        @ContactPerson = :contactPerson,
        @Position = :position,
        @DoNotShow = :doNotShow;",
      $parameters
    )->execute();
  }

  public static function update(PDO $pdo, array $parameters): bool {
    return PDOBuilder::createPreparedStatement(
      $pdo,
      "EXECUTE UpdateNonPartner
        @NonPartnerID = :nonPartnerId,
        @Name = :name,
        @Description = :description,
        @SponsorCode = :sponsorCode,
        @Email = :email,
        @Country = :country,
        @Website = :website,
        @LogoFile = :logoFile,
        @Note = :note,
        @Longitude = :longitude,
        @Latitude = :latitude,
        @EstimatedInv = :estimatedInvestment,
        @DoNotContact = :doNotContact,
        @CancerOnly = :cancerOnly,
        @ResearchFunder = :researchFunder,
        @ContactPerson = :contactPerson,
        @Position = :position,
        @DoNotShow = :doNotShow;",
      $parameters
    )->execute();
  }

}
