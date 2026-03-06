package com.CleanTogo.CleanTogoBackend.Entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "Commentaires_Reclamations")
@Data
@NoArgsConstructor
@AllArgsConstructor

public class Commentaire_Reclamation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "objet")
    private String objet;

    @Column(name = "description")
    private String description;

    @ManyToOne
    @JoinColumn(name="client_id")
    @JsonIgnore
    private Client client;
}
