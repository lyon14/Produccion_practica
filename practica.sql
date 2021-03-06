PGDMP     !    (                 y           practica    14.1    14.1 2    C           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            D           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            E           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            F           1262    16394    practica    DATABASE     d   CREATE DATABASE practica WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Spanish_Chile.1252';
    DROP DATABASE practica;
                postgres    false            ?            1255    16395    auto_evaluacion(bigint)    FUNCTION     ?  CREATE FUNCTION public.auto_evaluacion(id_prac bigint) RETURNS TABLE(titulo character varying, tipo_practica character varying, fecha_inio date, fecha_final date)
    LANGUAGE plpgsql
    AS $$
BEGIN
	return query select c.titulo, c.tipo_practica, c.fecha_inicio, c.fecha_termino from usuario as u
	join practicante as p on u.id_usuario=p.id_usuario
	join practica as c on p.id_practicante=c.id_practicante 
	where p.id_usuario = id_prac;
end;
$$;
 6   DROP FUNCTION public.auto_evaluacion(id_prac bigint);
       public          postgres    false            ?            1255    16396    evaluacion_empleador(bigint)    FUNCTION     ?  CREATE FUNCTION public.evaluacion_empleador(id_emp bigint) RETURNS TABLE(nombre character varying, rut character varying, tipo_practica character varying, carrera character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query select a.nombre_completo,a.rut,p.tipo_practica,c.nombre from practica as p
	join practicante as t on p.id_practicante = t.id
	join carrera as c on t.id_carrera = c.id
	join usuario as a on t.id_usuario = a.id
	where p.id_empleador = id_emp;
end;
$$;
 :   DROP FUNCTION public.evaluacion_empleador(id_emp bigint);
       public          postgres    false            ?            1255    16397 S   filtro_practicas_actuales_coordinador(bigint, character varying, character varying)    FUNCTION     ?  CREATE FUNCTION public.filtro_practicas_actuales_coordinador(estado_prac bigint, nomb_carr character varying, tip_pract character varying) RETURNS TABLE(nombre character varying, nombre_carr character varying, rut character varying, email character varying, id_pract integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	return query select m.nombre_completo,c.nombre_carrera,m.rut,m.email,a.id_practica 
	from usuario as m
	join practicante as p on p.id_usuario = m.id_usuario
	join carrera as c on c.id_carrera = p.id_carrera
	join practica as a on a.id_practicante = p.id_practicante
	where a.estado_practica = 0 OR c.nombre_carrera = nomb_carr OR a.tipo_practica = tip_pract;
	
end;
$$;
 ?   DROP FUNCTION public.filtro_practicas_actuales_coordinador(estado_prac bigint, nomb_carr character varying, tip_pract character varying);
       public          postgres    false            ?            1255    16398 O   filtro_tabla_evaluacion_empleador(bigint, character varying, character varying)    FUNCTION     ?  CREATE FUNCTION public.filtro_tabla_evaluacion_empleador(id_emp bigint, rut_prac character varying, nomb character varying) RETURNS TABLE(nombre character varying, rut character varying, tipo_practica character varying, carrera character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query select a.nombre_completo,a.rut,p.tipo_practica,c.nombre_carrera from practica as p
	join practicante as t on p.id_practicante = t.id_practicante
	join carrera as c on t.id_carrera = c.id_carrera
	join usuario as a on t.id_usuario = a.id_usuario
	where (p.id_empleador = id_emp AND a.rut = rut_prac) OR (p.id_empleador = id_emp AND a.nombre_completo = nomb);
end;
$$;
 {   DROP FUNCTION public.filtro_tabla_evaluacion_empleador(id_emp bigint, rut_prac character varying, nomb character varying);
       public          postgres    false            ?            1255    16399 >   filtro_tabla_soliticudes(character varying, character varying)    FUNCTION     e  CREATE FUNCTION public.filtro_tabla_soliticudes(tipo_pract character varying, nomb_carr character varying) RETURNS TABLE(nombre_c character varying, rut character varying, nombre_carr character varying, est_soli text, formu jsonb)
    LANGUAGE plpgsql
    AS $$
BEGIN
     return query select t.nombre_completo, t.rut, m.nombre_carrera, case when c.estado_solicitud = 0 then 'En espera'
											  when c.estado_solicitud = 1 then 'Rechazado'
											  when c.estado_solicitud = 2 then 'Aprobado'
											  end, c.formulario
											  
	from usuario as t
	join practicante as p on t.id_usuario = p.id_usuario
	join practica as a on p.id_practicante = a.id_practicante
	join solicitud as c on p.id_practicante = c.id_practicante
	join carrera as m on p.id_carrera = m.id_carrera
	where a.tipo_practica = tipo_pract or m.nombre_carrera = nomb_carr;
	
end;
$$;
 j   DROP FUNCTION public.filtro_tabla_soliticudes(tipo_pract character varying, nomb_carr character varying);
       public          postgres    false            ?            1255    16400 &   practicas_actuales_coordinador(bigint)    FUNCTION     ,  CREATE FUNCTION public.practicas_actuales_coordinador(estado_prac bigint) RETURNS TABLE(nombre character varying, nombre_carr character varying, rut character varying, email character varying, id_pract integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	return query select m.nombre_completo,c.nombre_carrera,m.rut,m.email,a.id_practica 
	from usuario as m
	join practicante as p on p.id_usuario = m.id_usuario
	join carrera as c on c.id_carrera = p.id_carrera
	join practica as a on a.id_practicante = p.id_practicante
	where a.estado_practica = 0;
	
end;
$$;
 I   DROP FUNCTION public.practicas_actuales_coordinador(estado_prac bigint);
       public          postgres    false            ?            1255    16401 '   rescata_evaluaciones(character varying)    FUNCTION     ?  CREATE FUNCTION public.rescata_evaluaciones(rut_prac character varying) RETURNS TABLE(formulario_pract jsonb, formulario_empleador jsonb)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query select c.formulario, m.formulario from usuario as a
	join practicante as p on a.id_usuario = p.id_usuario
	join autoevaluacion as c on p.id_practicante = c.id_practicante
	join evaluacion_empleador as m on p.id_practicante = m.id_practicante
	where a.rut = rut_prac;
end;
$$;
 G   DROP FUNCTION public.rescata_evaluaciones(rut_prac character varying);
       public          postgres    false            ?            1255    16402    tabla_auto_evaluacion(bigint)    FUNCTION     "  CREATE FUNCTION public.tabla_auto_evaluacion(id_prac bigint) RETURNS TABLE(titulo character varying, tipo_practica character varying, fecha_inio date, fecha_final date, formu jsonb)
    LANGUAGE plpgsql
    AS $$
BEGIN
	return query select c.titulo, c.tipo_practica, c.fecha_inicio, c.fecha_termino, a.formulario from usuario as u
	join practicante as p on u.id_usuario=p.id_usuario
	join autoevaluacion as a on p.id_practicante = a.id_practicante
	join practica as c on p.id_practicante=c.id_practicante 
	where p.id_usuario = id_prac;
end;
$$;
 <   DROP FUNCTION public.tabla_auto_evaluacion(id_prac bigint);
       public          postgres    false            ?            1255    16403 "   tabla_evaluacion_empleador(bigint)    FUNCTION     r  CREATE FUNCTION public.tabla_evaluacion_empleador(id_emp bigint) RETURNS TABLE(nombre character varying, rut character varying, tipo_practica character varying, carrera character varying, formu jsonb)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query select a.nombre_completo,a.rut,p.tipo_practica,c.nombre_carrera, e.formulario from practica as p
	join practicante as t on p.id_practicante = t.id_practicante
	join evaluacion_empleador as e on p.id_practicante = e.id_practicante
	join carrera as c on t.id_carrera = c.id_carrera
	join usuario as a on t.id_usuario = a.id_usuario
	where p.id_empleador = id_emp;
end;
$$;
 @   DROP FUNCTION public.tabla_evaluacion_empleador(id_emp bigint);
       public          postgres    false            ?            1255    16404    tabla_solicitudes()    FUNCTION     ?  CREATE FUNCTION public.tabla_solicitudes() RETURNS TABLE(nombre_c character varying, rut character varying, nombre_carr character varying, est_soli text, formu jsonb)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query select t.nombre_completo, t.rut, m.nombre_carrera, case when c.estado_solicitud = 0 then 'En espera'
											  when c.estado_solicitud = 1 then 'Rechazado'
											  when c.estado_solicitud = 2 then 'Aprobado'
											  end, c.formulario
											  
	from usuario as t
	join practicante as p on t.id_usuario = p.id_usuario
	join solicitud as c on p.id_practicante = c.id_practicante
	join carrera as m on p.id_carrera = m.id_carrera;
end;
$$;
 *   DROP FUNCTION public.tabla_solicitudes();
       public          postgres    false            ?            1259    16405    autoevaluacion    TABLE     ?   CREATE TABLE public.autoevaluacion (
    id_autoevaluacion integer NOT NULL,
    id_practicante bigint NOT NULL,
    id_empleador bigint NOT NULL,
    formulario jsonb
);
 "   DROP TABLE public.autoevaluacion;
       public         heap    postgres    false            ?            1259    16410    carrera    TABLE     ?   CREATE TABLE public.carrera (
    id_carrera integer NOT NULL,
    nombre_carrera character varying(50) NOT NULL,
    director character varying(50) NOT NULL
);
    DROP TABLE public.carrera;
       public         heap    postgres    false            ?            1259    16413    coordinador    TABLE     ?   CREATE TABLE public.coordinador (
    id_coordinador integer NOT NULL,
    departamento character varying(50) NOT NULL,
    carrera character varying(50) NOT NULL,
    id_usuario integer NOT NULL
);
    DROP TABLE public.coordinador;
       public         heap    postgres    false            ?            1259    16416 	   empleador    TABLE     ?   CREATE TABLE public.empleador (
    id_empleador integer NOT NULL,
    id_empresa bigint NOT NULL,
    id_usuario bigint NOT NULL
);
    DROP TABLE public.empleador;
       public         heap    postgres    false            ?            1259    16419    empresa    TABLE     ?   CREATE TABLE public.empresa (
    id_empresa integer NOT NULL,
    nombre_empresa character varying(60) NOT NULL,
    direccion character varying(60) NOT NULL,
    comuna character varying(50) NOT NULL
);
    DROP TABLE public.empresa;
       public         heap    postgres    false            ?            1259    16422    evaluacion_empleador    TABLE     ?   CREATE TABLE public.evaluacion_empleador (
    id_evaluacion_empleador integer NOT NULL,
    id_empleador bigint NOT NULL,
    id_practicante bigint NOT NULL,
    formulario jsonb
);
 (   DROP TABLE public.evaluacion_empleador;
       public         heap    postgres    false            ?            1259    16427    evaluacion_ucen    TABLE     (  CREATE TABLE public.evaluacion_ucen (
    id_eva_ucen integer NOT NULL,
    id_coordinador bigint NOT NULL,
    id_practica bigint NOT NULL,
    id_evaluacion_empleador bigint NOT NULL,
    id_autoevaluacion bigint NOT NULL,
    fecha_evaluacion date NOT NULL,
    nota bit varying[] NOT NULL
);
 #   DROP TABLE public.evaluacion_ucen;
       public         heap    postgres    false            ?            1259    16432    practica    TABLE     ?  CREATE TABLE public.practica (
    id_practica integer NOT NULL,
    titulo character varying(50) NOT NULL,
    tipo_practica character varying(50) NOT NULL,
    beneficios character varying(80) NOT NULL,
    estado_practica integer NOT NULL,
    estado_convocatoria integer NOT NULL,
    fecha_postulacion date NOT NULL,
    finfecha_postulacion date NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_termino date NOT NULL,
    id_practicante bigint NOT NULL,
    id_empleador bigint
);
    DROP TABLE public.practica;
       public         heap    postgres    false            ?            1259    16435    practicante    TABLE     ?   CREATE TABLE public.practicante (
    id_practicante integer NOT NULL,
    id_carrera bigint NOT NULL,
    id_usuario bigint NOT NULL
);
    DROP TABLE public.practicante;
       public         heap    postgres    false            ?            1259    16438 	   solicitud    TABLE     ?   CREATE TABLE public.solicitud (
    id_solicitud integer NOT NULL,
    id_practicante bigint NOT NULL,
    estado_solicitud integer DEFAULT 0,
    formulario jsonb
);
    DROP TABLE public.solicitud;
       public         heap    postgres    false            ?            1259    16444    tipo_practica    TABLE     ?   CREATE TABLE public.tipo_practica (
    tipo_practica character varying(60) NOT NULL,
    cantidad_de_horas character varying(30) NOT NULL,
    descripcion character varying(100) NOT NULL,
    descriptor character varying(100) NOT NULL
);
 !   DROP TABLE public.tipo_practica;
       public         heap    postgres    false            ?            1259    16447    usuario    TABLE     P  CREATE TABLE public.usuario (
    id_usuario integer NOT NULL,
    tipo_usuario character varying(30) NOT NULL,
    nombre_completo character varying(50) NOT NULL,
    rut character varying(15) NOT NULL,
    email character varying(50) NOT NULL,
    telefono character varying(18) NOT NULL,
    contrasena character varying NOT NULL
);
    DROP TABLE public.usuario;
       public         heap    postgres    false            5          0    16405    autoevaluacion 
   TABLE DATA           e   COPY public.autoevaluacion (id_autoevaluacion, id_practicante, id_empleador, formulario) FROM stdin;
    public          postgres    false    209   )R       6          0    16410    carrera 
   TABLE DATA           G   COPY public.carrera (id_carrera, nombre_carrera, director) FROM stdin;
    public          postgres    false    210   RR       7          0    16413    coordinador 
   TABLE DATA           X   COPY public.coordinador (id_coordinador, departamento, carrera, id_usuario) FROM stdin;
    public          postgres    false    211   ?R       8          0    16416 	   empleador 
   TABLE DATA           I   COPY public.empleador (id_empleador, id_empresa, id_usuario) FROM stdin;
    public          postgres    false    212   ?R       9          0    16419    empresa 
   TABLE DATA           P   COPY public.empresa (id_empresa, nombre_empresa, direccion, comuna) FROM stdin;
    public          postgres    false    213   S       :          0    16422    evaluacion_empleador 
   TABLE DATA           q   COPY public.evaluacion_empleador (id_evaluacion_empleador, id_empleador, id_practicante, formulario) FROM stdin;
    public          postgres    false    214   ?S       ;          0    16427    evaluacion_ucen 
   TABLE DATA           ?   COPY public.evaluacion_ucen (id_eva_ucen, id_coordinador, id_practica, id_evaluacion_empleador, id_autoevaluacion, fecha_evaluacion, nota) FROM stdin;
    public          postgres    false    215   ?S       <          0    16432    practica 
   TABLE DATA           ?   COPY public.practica (id_practica, titulo, tipo_practica, beneficios, estado_practica, estado_convocatoria, fecha_postulacion, finfecha_postulacion, fecha_inicio, fecha_termino, id_practicante, id_empleador) FROM stdin;
    public          postgres    false    216   ?S       =          0    16435    practicante 
   TABLE DATA           M   COPY public.practicante (id_practicante, id_carrera, id_usuario) FROM stdin;
    public          postgres    false    217   ?T       >          0    16438 	   solicitud 
   TABLE DATA           _   COPY public.solicitud (id_solicitud, id_practicante, estado_solicitud, formulario) FROM stdin;
    public          postgres    false    218   ?T       ?          0    16444    tipo_practica 
   TABLE DATA           b   COPY public.tipo_practica (tipo_practica, cantidad_de_horas, descripcion, descriptor) FROM stdin;
    public          postgres    false    219   V       @          0    16447    usuario 
   TABLE DATA           n   COPY public.usuario (id_usuario, tipo_usuario, nombre_completo, rut, email, telefono, contrasena) FROM stdin;
    public          postgres    false    220   kV       ?           2606    16453 "   autoevaluacion autoevaluacion_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.autoevaluacion
    ADD CONSTRAINT autoevaluacion_pkey PRIMARY KEY (id_autoevaluacion);
 L   ALTER TABLE ONLY public.autoevaluacion DROP CONSTRAINT autoevaluacion_pkey;
       public            postgres    false    209            ?           2606    16455    carrera carrera_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.carrera
    ADD CONSTRAINT carrera_pkey PRIMARY KEY (id_carrera);
 >   ALTER TABLE ONLY public.carrera DROP CONSTRAINT carrera_pkey;
       public            postgres    false    210            ?           2606    16457    coordinador coordinador_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.coordinador
    ADD CONSTRAINT coordinador_pkey PRIMARY KEY (id_coordinador);
 F   ALTER TABLE ONLY public.coordinador DROP CONSTRAINT coordinador_pkey;
       public            postgres    false    211            ?           2606    16459    empleador empelador_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.empleador
    ADD CONSTRAINT empelador_pkey PRIMARY KEY (id_empleador);
 B   ALTER TABLE ONLY public.empleador DROP CONSTRAINT empelador_pkey;
       public            postgres    false    212            ?           2606    16461    empresa empresa_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_pkey PRIMARY KEY (id_empresa);
 >   ALTER TABLE ONLY public.empresa DROP CONSTRAINT empresa_pkey;
       public            postgres    false    213            ?           2606    16463 .   evaluacion_empleador evaluacion_empleador_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.evaluacion_empleador
    ADD CONSTRAINT evaluacion_empleador_pkey PRIMARY KEY (id_evaluacion_empleador);
 X   ALTER TABLE ONLY public.evaluacion_empleador DROP CONSTRAINT evaluacion_empleador_pkey;
       public            postgres    false    214            ?           2606    16465 $   evaluacion_ucen evaluacion_ucen_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.evaluacion_ucen
    ADD CONSTRAINT evaluacion_ucen_pkey PRIMARY KEY (id_eva_ucen);
 N   ALTER TABLE ONLY public.evaluacion_ucen DROP CONSTRAINT evaluacion_ucen_pkey;
       public            postgres    false    215            ?           2606    16467    practica practica_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.practica
    ADD CONSTRAINT practica_pkey PRIMARY KEY (id_practica);
 @   ALTER TABLE ONLY public.practica DROP CONSTRAINT practica_pkey;
       public            postgres    false    216            ?           2606    16469    practicante practicante_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.practicante
    ADD CONSTRAINT practicante_pkey PRIMARY KEY (id_practicante);
 F   ALTER TABLE ONLY public.practicante DROP CONSTRAINT practicante_pkey;
       public            postgres    false    217            ?           2606    16471    solicitud solicitud_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.solicitud
    ADD CONSTRAINT solicitud_pkey PRIMARY KEY (id_solicitud);
 B   ALTER TABLE ONLY public.solicitud DROP CONSTRAINT solicitud_pkey;
       public            postgres    false    218            ?           2606    16473     tipo_practica tipo_practica_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.tipo_practica
    ADD CONSTRAINT tipo_practica_pkey PRIMARY KEY (tipo_practica);
 J   ALTER TABLE ONLY public.tipo_practica DROP CONSTRAINT tipo_practica_pkey;
       public            postgres    false    219            ?           2606    16475    usuario usuario_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);
 >   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_pkey;
       public            postgres    false    220            5      x?3?4??.#N2b???? *p      6   f   x?3???K?Sp?,??QH?Sp??-(-IL?<?9O!U?3/-?(????Dΰ????"?Ԓļ??Ң?Ғ??+??R??????K)-.)?L???)F??? ~!0&      7      x?3?t (i????? -?      8      x?3?4?4?2?4?4?????? @      9   ?   x?%?A
1E??)r????kq?Xܹ?m???HZ
^ͭ?0?????!?*?
???6`?'?T-8?~G?????p??FUM?β?<sₓF???K??V$Q?=?j4C???a?7~?*t?EQw?sI?1N      :      x?3?4??.#N2b???? *p      ;      x?????? ? ?      <   ?   x???1?0??>??T??#???.l,Vj?JmR%???JT\ yy?????e?V開Ot-9-tI??P;??!'????䩾l??I?f>??5W`PV	?A?;??To????z???ܣ??6???A?7:B?      =      x?3?4?4?2?F\1z\\\ 	      >   g  x?͓?J?0ǯۧ(?Օ??֫??fz-J??Ό|?4U??@>?/f?vZF?m"i?9?$??8??[???????#???zq1?$r/??RH???=׿E???D??oB?Q9??](󲬝??d??H?$(KgϢ6Y`?Ёz? ?m?8Գ.\{?$??F?[I?Z??u"S?H%?J"?^Z?J??Dp4?`?*	u[?bM???Rp1??,N???D??Z?#????~?n?Ùqһ?<h??=.??,?Վ?I?8???`DF??q5???<!VQ?u?ÑDI???t??#?&S/?H'?%??@$?!?o?????\?"g?E?o?1Q?D???$?8?E??F??K??m???L      ?   <   x?(JL.?LNT?/H23??s8??2??99?`*???R?!*L?U??qqq ??L      @     x?u??j?0???Sx/?TcnB??B?????K???????9?b?h????%??7a*"??(???G?Ɔ?????DޔX??h?O?????0⬴?"YT??F6{?X?A??j?C?g??????L??
nXߘ,????,???R??f???J?O?_??X?????f???(?=+7??????|????_??LUH8/?7???=?;?kP!???????{?ym?Ƒ?T??AT?n???kL;?1˲o?V     