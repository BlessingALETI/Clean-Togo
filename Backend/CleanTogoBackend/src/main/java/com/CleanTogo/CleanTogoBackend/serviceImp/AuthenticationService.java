package com.CleanTogo.CleanTogoBackend.serviceImp;

import com.CleanTogo.CleanTogoBackend.Configs.JwtService;
import com.CleanTogo.CleanTogoBackend.Entities.*;
import com.CleanTogo.CleanTogoBackend.dto.AuthenticationRequest;
import com.CleanTogo.CleanTogoBackend.dto.AuthenticationResponse;
import com.CleanTogo.CleanTogoBackend.dto.RegisterRequest;
import com.CleanTogo.CleanTogoBackend.repositories.UtilisateurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthenticationService {
    private final UtilisateurRepository repository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    public AuthenticationResponse register(RegisterRequest request) {
        if (request.getEmail() == null || request.getEmail().isBlank()) {
            throw new IllegalArgumentException("email is required");
        }
        if (request.getPassword() == null || request.getPassword().isBlank()) {
            throw new IllegalArgumentException("password is required");
        }
        if (repository.findByEmail(request.getEmail()).isPresent()) {
            throw new IllegalArgumentException("email already exists");
        }

        Utilisateur user;
        Role role = request.getRole() != null ? request.getRole() : Role.CLIENT;

        switch (role) {
            case CLIENT:
                user = new Client();
                break;
            case CHAUFFEUR:
                user = new Chauffeur();
                break;
            case ADMIN:
                user = new Administrateur();
                break;
            default:
                user = new Utilisateur();
                break;
        }

        user.setPrenom(request.getPrenom());
        user.setNom(request.getNom());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(role);
        user.setPhone(request.getPhone());
        user.setStatut(request.isStatut());

        String username = request.getUsername();
        if (username == null || username.isBlank()) {
            String prenom = request.getPrenom() != null ? request.getPrenom() : "";
            String nom = request.getNom() != null ? request.getNom() : "";
            username = (prenom + " " + nom).trim();
            if (username.isBlank()) {
                username = "user" + (System.currentTimeMillis() % 1_000_000);
            }
        }
        user.setUsername(username);

        repository.save(user);
        var jwtToken = jwtService.generateToken(user);
        return AuthenticationResponse.builder()
                .token(jwtToken)
                .username(user.getRealUsername())
                .email(user.getEmail())
                .role(user.getRole().name())
                .build();
    }

    public AuthenticationResponse authenticate(AuthenticationRequest request) {
        if (request.getEmail() == null || request.getEmail().isBlank()) {
            throw new IllegalArgumentException("email is required");
        }
        if (request.getPassword() == null || request.getPassword().isBlank()) {
            throw new IllegalArgumentException("password is required");
        }
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );
        var user = repository.findByEmail(request.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("user not found"));
        var jwtToken = jwtService.generateToken(user);
        return AuthenticationResponse.builder()
                .token(jwtToken)
                .username(user.getRealUsername())
                .email(user.getEmail())
                .role(user.getRole().name())
                .build();
    }
}
