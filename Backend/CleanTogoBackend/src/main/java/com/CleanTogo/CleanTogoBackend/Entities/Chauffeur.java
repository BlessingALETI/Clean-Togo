package com.CleanTogo.CleanTogoBackend.Entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.File;
import java.util.List;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@DiscriminatorValue("CHAUFFEUR")

public class Chauffeur extends Utilisateur {
    @Column(name = "permis")
    private String permis;

}
