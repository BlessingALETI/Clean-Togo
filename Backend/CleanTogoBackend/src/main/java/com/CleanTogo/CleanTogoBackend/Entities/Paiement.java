package com.CleanTogo.CleanTogoBackend.Entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;

@Entity
@Table(name = "Paiements")
@Data
@NoArgsConstructor
@AllArgsConstructor

public class Paiement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "nomModePaiement")
    private String nomModePaiement;

    @Column(name = "numero")
    private String numero;

    @Column(name = "montant")
    private float montant;

    @Column(name = "dateVersement")
    private Date dateVersement;

    @ManyToOne
    @JoinColumn(name="client_id")
    @JsonIgnore
    private Client client;
}
