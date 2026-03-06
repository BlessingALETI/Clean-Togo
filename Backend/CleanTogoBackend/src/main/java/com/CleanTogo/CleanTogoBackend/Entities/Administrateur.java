package com.CleanTogo.CleanTogoBackend.Entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.File;
import java.util.List;

@Entity
@Data
@NoArgsConstructor
@DiscriminatorValue("ADMINSTRATEUR")

public class Administrateur extends  Utilisateur{
}
