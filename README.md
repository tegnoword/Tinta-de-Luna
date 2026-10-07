# Tinta de Luna

```
flowchart TD
    %% Nodos de la Interfaz (Frontend)
    subgraph UI [Frontend - Interfaz de Usuario]
        A[Lista de Poemas / Home] -->|Crear / Editar| B[Editor de Poemas]
        B -->|Clic en Guardar| C{¿Título único?}
        B -->|Clic en Enviar| D[Vista Previa de la Carta]
    end

    %% Nodos de la Base de Datos (SQLite / MySQL)
    subgraph DB [Base de Datos - Tabla poem]
        E[(DB: poem)]
    end

    %% Nodos de Lógica e Integración
    subgraph Logic [Logica & Servicios]
        F[Carta Helper / Formateador]
        G[URL Encoder & Deep Link Service]
    end

    %% App Externa
    subgraph External [App Externa]
        H[WhatsApp Client]
    end

    %% Conexiones e Interacciones
    C -->|Sí| E
    C -->|No: Error Unique| B
    E -->|Carga poemas| A
    
    D -->|Envía poema| F
    F -->|Aplica negritas, emojis y marcos| G
    G -->|Actualiza status = 'sent'| E
    G -->|Abre https://wa.me/...| H

    %% Estilos
    classDef ui fill:#e1f5fe,stroke:#0288d1,stroke-width:2px;
    classDef db fill:#fff3e0,stroke:#f57c00,stroke-width:2px;
    classDef logic fill:#e8f5e9,stroke:#388e3c,stroke-width:2px;
    classDef ext fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px;

    class A,B,C,D ui;
    class E db;
    class F,G logic;
    class H ext;
```