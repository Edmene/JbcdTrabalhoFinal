CREATE TABLE cliente
(
    id INTEGER PRIMARY KEY NOT NULL,
    bandeiracc VARCHAR(100) NOT NULL,
    numerocc VARCHAR(50) NOT NULL,
    CONSTRAINT fk_cliente_pessoa FOREIGN KEY (id) REFERENCES pessoa (id)
);
CREATE TABLE item_venda
(
    id INTEGER DEFAULT nextval('item_venda_id_seq'::regclass) NOT NULL,
    fk_item_produto INTEGER NOT NULL,
    preco MONEY NOT NULL,
    CONSTRAINT item_venda_pkey PRIMARY KEY (id, fk_item_produto),
    CONSTRAINT item_produto FOREIGN KEY (fk_item_produto) REFERENCES produto (id)
);
CREATE TABLE lista_venda
(
    id INTEGER DEFAULT nextval('lista_venda_id_seq'::regclass) NOT NULL,
    lista_item_id INTEGER NOT NULL,
    lista_item_prod INTEGER NOT NULL,
    venda_item INTEGER NOT NULL,
    CONSTRAINT lista_venda_pkey PRIMARY KEY (id, lista_item_id, lista_item_prod, venda_item),
    CONSTRAINT fk_lista_item FOREIGN KEY (lista_item_id, lista_item_prod) REFERENCES item_venda (id, fk_item_produto),
    CONSTRAINT fk_venda_item FOREIGN KEY (venda_item) REFERENCES venda (id)
);
CREATE TABLE pessoa
(
    id INTEGER DEFAULT nextval('pessoa_id_seq'::regclass) PRIMARY KEY NOT NULL,
    cpf VARCHAR(11) NOT NULL,
    nome VARCHAR(150) NOT NULL,
    sobrenome VARCHAR(200) NOT NULL
);
CREATE UNIQUE INDEX uniq_cpf_pessoa ON pessoa (cpf);
CREATE TABLE produto
(
    id INTEGER DEFAULT nextval('produto_id_seq'::regclass) PRIMARY KEY NOT NULL,
    nome VARCHAR(80) NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    preco MONEY NOT NULL
);
CREATE UNIQUE INDEX uniq_nome_produto ON produto (nome);
CREATE TABLE venda
(
    id INTEGER DEFAULT nextval('venda_id_seq'::regclass) PRIMARY KEY NOT NULL,
    venda_cliente INTEGER NOT NULL,
    data DATE NOT NULL,
    valor_total MONEY NOT NULL,
    status BOOLEAN NOT NULL,
    CONSTRAINT fk_venda_cliente FOREIGN KEY (venda_cliente) REFERENCES cliente (id)
);
CREATE TABLE pg_aggregate
(
    aggfnoid REGPROC NOT NULL,
    aggkind "char" NOT NULL,
    aggnumdirectargs SMALLINT NOT NULL,
    aggtransfn REGPROC NOT NULL,
    aggfinalfn REGPROC NOT NULL,
    aggmtransfn REGPROC NOT NULL,
    aggminvtransfn REGPROC NOT NULL,
    aggmfinalfn REGPROC NOT NULL,
    aggfinalextra BOOLEAN NOT NULL,
    aggmfinalextra BOOLEAN NOT NULL,
    aggsortop OID NOT NULL,
    aggtranstype OID NOT NULL,
    aggtransspace INTEGER NOT NULL,
    aggmtranstype OID NOT NULL,
    aggmtransspace INTEGER NOT NULL,
    agginitval TEXT,
    aggminitval TEXT
);
CREATE UNIQUE INDEX pg_aggregate_fnoid_index ON pg_aggregate (aggfnoid);
CREATE TABLE pg_am
(
    amname NAME NOT NULL,
    amstrategies SMALLINT NOT NULL,
    amsupport SMALLINT NOT NULL,
    amcanorder BOOLEAN NOT NULL,
    amcanorderbyop BOOLEAN NOT NULL,
    amcanbackward BOOLEAN NOT NULL,
    amcanunique BOOLEAN NOT NULL,
    amcanmulticol BOOLEAN NOT NULL,
    amoptionalkey BOOLEAN NOT NULL,
    amsearcharray BOOLEAN NOT NULL,
    amsearchnulls BOOLEAN NOT NULL,
    amstorage BOOLEAN NOT NULL,
    amclusterable BOOLEAN NOT NULL,
    ampredlocks BOOLEAN NOT NULL,
    amkeytype OID NOT NULL,
    aminsert REGPROC NOT NULL,
    ambeginscan REGPROC NOT NULL,
    amgettuple REGPROC NOT NULL,
    amgetbitmap REGPROC NOT NULL,
    amrescan REGPROC NOT NULL,
    amendscan REGPROC NOT NULL,
    ammarkpos REGPROC NOT NULL,
    amrestrpos REGPROC NOT NULL,
    ambuild REGPROC NOT NULL,
    ambuildempty REGPROC NOT NULL,
    ambulkdelete REGPROC NOT NULL,
    amvacuumcleanup REGPROC NOT NULL,
    amcanreturn REGPROC NOT NULL,
    amcostestimate REGPROC NOT NULL,
    amoptions REGPROC NOT NULL
);
CREATE UNIQUE INDEX pg_am_oid_index ON pg_am (oid);
CREATE UNIQUE INDEX pg_am_name_index ON pg_am (amname);
CREATE TABLE pg_amop
(
    amopfamily OID NOT NULL,
    amoplefttype OID NOT NULL,
    amoprighttype OID NOT NULL,
    amopstrategy SMALLINT NOT NULL,
    amoppurpose "char" NOT NULL,
    amopopr OID NOT NULL,
    amopmethod OID NOT NULL,
    amopsortfamily OID NOT NULL
);
CREATE UNIQUE INDEX pg_amop_oid_index ON pg_amop (oid);
CREATE UNIQUE INDEX pg_amop_fam_strat_index ON pg_amop (amopfamily, amoplefttype, amoprighttype, amopstrategy);
CREATE UNIQUE INDEX pg_amop_opr_fam_index ON pg_amop (amopopr, amoppurpose, amopfamily);
CREATE TABLE pg_amproc
(
    amprocfamily OID NOT NULL,
    amproclefttype OID NOT NULL,
    amprocrighttype OID NOT NULL,
    amprocnum SMALLINT NOT NULL,
    amproc REGPROC NOT NULL
);
CREATE UNIQUE INDEX pg_amproc_oid_index ON pg_amproc (oid);
CREATE UNIQUE INDEX pg_amproc_fam_proc_index ON pg_amproc (amprocfamily, amproclefttype, amprocrighttype, amprocnum);
CREATE TABLE pg_attrdef
(
    adrelid OID NOT NULL,
    adnum SMALLINT NOT NULL,
    adbin PG_NODE_TREE,
    adsrc TEXT
);
CREATE UNIQUE INDEX pg_attrdef_oid_index ON pg_attrdef (oid);
CREATE UNIQUE INDEX pg_attrdef_adrelid_adnum_index ON pg_attrdef (adrelid, adnum);
CREATE TABLE pg_attribute
(
    attrelid OID NOT NULL,
    attname NAME NOT NULL,
    atttypid OID NOT NULL,
    attstattarget INTEGER NOT NULL,
    attlen SMALLINT NOT NULL,
    attnum SMALLINT NOT NULL,
    attndims INTEGER NOT NULL,
    attcacheoff INTEGER NOT NULL,
    atttypmod INTEGER NOT NULL,
    attbyval BOOLEAN NOT NULL,
    attstorage "char" NOT NULL,
    attalign "char" NOT NULL,
    attnotnull BOOLEAN NOT NULL,
    atthasdef BOOLEAN NOT NULL,
    attisdropped BOOLEAN NOT NULL,
    attislocal BOOLEAN NOT NULL,
    attinhcount INTEGER NOT NULL,
    attcollation OID NOT NULL,
    attacl ACLITEM[],
    attoptions TEXT[],
    attfdwoptions TEXT[]
);
CREATE UNIQUE INDEX pg_attribute_relid_attnam_index ON pg_attribute (attrelid, attname);
CREATE UNIQUE INDEX pg_attribute_relid_attnum_index ON pg_attribute (attrelid, attnum);
CREATE TABLE pg_auth_members
(
    roleid OID NOT NULL,
    member OID NOT NULL,
    grantor OID NOT NULL,
    admin_option BOOLEAN NOT NULL
);
CREATE UNIQUE INDEX pg_auth_members_role_member_index ON pg_auth_members (roleid, member);
CREATE UNIQUE INDEX pg_auth_members_member_role_index ON pg_auth_members (member, roleid);
CREATE TABLE pg_authid
(
    rolname NAME NOT NULL,
    rolsuper BOOLEAN NOT NULL,
    rolinherit BOOLEAN NOT NULL,
    rolcreaterole BOOLEAN NOT NULL,
    rolcreatedb BOOLEAN NOT NULL,
    rolcanlogin BOOLEAN NOT NULL,
    rolreplication BOOLEAN NOT NULL,
    rolbypassrls BOOLEAN NOT NULL,
    rolconnlimit INTEGER NOT NULL,
    rolpassword TEXT,
    rolvaliduntil TIMESTAMP WITH TIME ZONE
);
CREATE UNIQUE INDEX pg_authid_oid_index ON pg_authid (oid);
CREATE UNIQUE INDEX pg_authid_rolname_index ON pg_authid (rolname);
CREATE TABLE pg_cast
(
    castsource OID NOT NULL,
    casttarget OID NOT NULL,
    castfunc OID NOT NULL,
    castcontext "char" NOT NULL,
    castmethod "char" NOT NULL
);
CREATE UNIQUE INDEX pg_cast_oid_index ON pg_cast (oid);
CREATE UNIQUE INDEX pg_cast_source_target_index ON pg_cast (castsource, casttarget);
CREATE TABLE pg_class
(
    relname NAME NOT NULL,
    relnamespace OID NOT NULL,
    reltype OID NOT NULL,
    reloftype OID NOT NULL,
    relowner OID NOT NULL,
    relam OID NOT NULL,
    relfilenode OID NOT NULL,
    reltablespace OID NOT NULL,
    relpages INTEGER NOT NULL,
    reltuples REAL NOT NULL,
    relallvisible INTEGER NOT NULL,
    reltoastrelid OID NOT NULL,
    relhasindex BOOLEAN NOT NULL,
    relisshared BOOLEAN NOT NULL,
    relpersistence "char" NOT NULL,
    relkind "char" NOT NULL,
    relnatts SMALLINT NOT NULL,
    relchecks SMALLINT NOT NULL,
    relhasoids BOOLEAN NOT NULL,
    relhaspkey BOOLEAN NOT NULL,
    relhasrules BOOLEAN NOT NULL,
    relhastriggers BOOLEAN NOT NULL,
    relhassubclass BOOLEAN NOT NULL,
    relrowsecurity BOOLEAN NOT NULL,
    relforcerowsecurity BOOLEAN NOT NULL,
    relispopulated BOOLEAN NOT NULL,
    relreplident "char" NOT NULL,
    relfrozenxid XID NOT NULL,
    relminmxid XID NOT NULL,
    relacl ACLITEM[],
    reloptions TEXT[]
);
CREATE UNIQUE INDEX pg_class_oid_index ON pg_class (oid);
CREATE UNIQUE INDEX pg_class_relname_nsp_index ON pg_class (relname, relnamespace);
CREATE INDEX pg_class_tblspc_relfilenode_index ON pg_class (reltablespace, relfilenode);
CREATE TABLE pg_collation
(
    collname NAME NOT NULL,
    collnamespace OID NOT NULL,
    collowner OID NOT NULL,
    collencoding INTEGER NOT NULL,
    collcollate NAME NOT NULL,
    collctype NAME NOT NULL
);
CREATE UNIQUE INDEX pg_collation_oid_index ON pg_collation (oid);
CREATE UNIQUE INDEX pg_collation_name_enc_nsp_index ON pg_collation (collname, collencoding, collnamespace);
CREATE TABLE pg_constraint
(
    conname NAME NOT NULL,
    connamespace OID NOT NULL,
    contype "char" NOT NULL,
    condeferrable BOOLEAN NOT NULL,
    condeferred BOOLEAN NOT NULL,
    convalidated BOOLEAN NOT NULL,
    conrelid OID NOT NULL,
    contypid OID NOT NULL,
    conindid OID NOT NULL,
    confrelid OID NOT NULL,
    confupdtype "char" NOT NULL,
    confdeltype "char" NOT NULL,
    confmatchtype "char" NOT NULL,
    conislocal BOOLEAN NOT NULL,
    coninhcount INTEGER NOT NULL,
    connoinherit BOOLEAN NOT NULL,
    conkey SMALLINT[],
    confkey SMALLINT[],
    conpfeqop OID[],
    conppeqop OID[],
    conffeqop OID[],
    conexclop OID[],
    conbin PG_NODE_TREE,
    consrc TEXT
);
CREATE UNIQUE INDEX pg_constraint_oid_index ON pg_constraint (oid);
CREATE INDEX pg_constraint_conname_nsp_index ON pg_constraint (conname, connamespace);
CREATE INDEX pg_constraint_conrelid_index ON pg_constraint (conrelid);
CREATE INDEX pg_constraint_contypid_index ON pg_constraint (contypid);
CREATE TABLE pg_conversion
(
    conname NAME NOT NULL,
    connamespace OID NOT NULL,
    conowner OID NOT NULL,
    conforencoding INTEGER NOT NULL,
    contoencoding INTEGER NOT NULL,
    conproc REGPROC NOT NULL,
    condefault BOOLEAN NOT NULL
);
CREATE UNIQUE INDEX pg_conversion_oid_index ON pg_conversion (oid);
CREATE UNIQUE INDEX pg_conversion_name_nsp_index ON pg_conversion (conname, connamespace);
CREATE UNIQUE INDEX pg_conversion_default_index ON pg_conversion (connamespace, conforencoding, contoencoding, oid);
CREATE TABLE pg_database
(
    datname NAME NOT NULL,
    datdba OID NOT NULL,
    encoding INTEGER NOT NULL,
    datcollate NAME NOT NULL,
    datctype NAME NOT NULL,
    datistemplate BOOLEAN NOT NULL,
    datallowconn BOOLEAN NOT NULL,
    datconnlimit INTEGER NOT NULL,
    datlastsysoid OID NOT NULL,
    datfrozenxid XID NOT NULL,
    datminmxid XID NOT NULL,
    dattablespace OID NOT NULL,
    datacl ACLITEM[]
);
CREATE UNIQUE INDEX pg_database_oid_index ON pg_database (oid);
CREATE UNIQUE INDEX pg_database_datname_index ON pg_database (datname);
CREATE TABLE pg_db_role_setting
(
    setdatabase OID NOT NULL,
    setrole OID NOT NULL,
    setconfig TEXT[]
);
CREATE UNIQUE INDEX pg_db_role_setting_databaseid_rol_index ON pg_db_role_setting (setdatabase, setrole);
CREATE TABLE pg_default_acl
(
    defaclrole OID NOT NULL,
    defaclnamespace OID NOT NULL,
    defaclobjtype "char" NOT NULL,
    defaclacl ACLITEM[]
);
CREATE UNIQUE INDEX pg_default_acl_oid_index ON pg_default_acl (oid);
CREATE UNIQUE INDEX pg_default_acl_role_nsp_obj_index ON pg_default_acl (defaclrole, defaclnamespace, defaclobjtype);
CREATE TABLE pg_depend
(
    classid OID NOT NULL,
    objid OID NOT NULL,
    objsubid INTEGER NOT NULL,
    refclassid OID NOT NULL,
    refobjid OID NOT NULL,
    refobjsubid INTEGER NOT NULL,
    deptype "char" NOT NULL
);
CREATE INDEX pg_depend_depender_index ON pg_depend (classid, objid, objsubid);
CREATE INDEX pg_depend_reference_index ON pg_depend (refclassid, refobjid, refobjsubid);
CREATE TABLE pg_description
(
    objoid OID NOT NULL,
    classoid OID NOT NULL,
    objsubid INTEGER NOT NULL,
    description TEXT NOT NULL
);
CREATE UNIQUE INDEX pg_description_o_c_o_index ON pg_description (objoid, classoid, objsubid);
CREATE TABLE pg_enum
(
    enumtypid OID NOT NULL,
    enumsortorder REAL NOT NULL,
    enumlabel NAME NOT NULL
);
CREATE UNIQUE INDEX pg_enum_oid_index ON pg_enum (oid);
CREATE UNIQUE INDEX pg_enum_typid_sortorder_index ON pg_enum (enumtypid, enumsortorder);
CREATE UNIQUE INDEX pg_enum_typid_label_index ON pg_enum (enumtypid, enumlabel);
CREATE TABLE pg_event_trigger
(
    evtname NAME NOT NULL,
    evtevent NAME NOT NULL,
    evtowner OID NOT NULL,
    evtfoid OID NOT NULL,
    evtenabled "char" NOT NULL,
    evttags TEXT[]
);
CREATE UNIQUE INDEX pg_event_trigger_oid_index ON pg_event_trigger (oid);
CREATE UNIQUE INDEX pg_event_trigger_evtname_index ON pg_event_trigger (evtname);
CREATE TABLE pg_extension
(
    extname NAME NOT NULL,
    extowner OID NOT NULL,
    extnamespace OID NOT NULL,
    extrelocatable BOOLEAN NOT NULL,
    extversion TEXT NOT NULL,
    extconfig OID[],
    extcondition TEXT[]
);
CREATE UNIQUE INDEX pg_extension_oid_index ON pg_extension (oid);
CREATE UNIQUE INDEX pg_extension_name_index ON pg_extension (extname);
CREATE TABLE pg_foreign_data_wrapper
(
    fdwname NAME NOT NULL,
    fdwowner OID NOT NULL,
    fdwhandler OID NOT NULL,
    fdwvalidator OID NOT NULL,
    fdwacl ACLITEM[],
    fdwoptions TEXT[]
);
CREATE UNIQUE INDEX pg_foreign_data_wrapper_oid_index ON pg_foreign_data_wrapper (oid);
CREATE UNIQUE INDEX pg_foreign_data_wrapper_name_index ON pg_foreign_data_wrapper (fdwname);
CREATE TABLE pg_foreign_server
(
    srvname NAME NOT NULL,
    srvowner OID NOT NULL,
    srvfdw OID NOT NULL,
    srvtype TEXT,
    srvversion TEXT,
    srvacl ACLITEM[],
    srvoptions TEXT[]
);
CREATE UNIQUE INDEX pg_foreign_server_oid_index ON pg_foreign_server (oid);
CREATE UNIQUE INDEX pg_foreign_server_name_index ON pg_foreign_server (srvname);
CREATE TABLE pg_foreign_table
(
    ftrelid OID NOT NULL,
    ftserver OID NOT NULL,
    ftoptions TEXT[]
);
CREATE UNIQUE INDEX pg_foreign_table_relid_index ON pg_foreign_table (ftrelid);
CREATE TABLE pg_index
(
    indexrelid OID NOT NULL,
    indrelid OID NOT NULL,
    indnatts SMALLINT NOT NULL,
    indisunique BOOLEAN NOT NULL,
    indisprimary BOOLEAN NOT NULL,
    indisexclusion BOOLEAN NOT NULL,
    indimmediate BOOLEAN NOT NULL,
    indisclustered BOOLEAN NOT NULL,
    indisvalid BOOLEAN NOT NULL,
    indcheckxmin BOOLEAN NOT NULL,
    indisready BOOLEAN NOT NULL,
    indislive BOOLEAN NOT NULL,
    indisreplident BOOLEAN NOT NULL,
    indkey INT2VECTOR NOT NULL,
    indcollation OIDVECTOR NOT NULL,
    indclass OIDVECTOR NOT NULL,
    indoption INT2VECTOR NOT NULL,
    indexprs PG_NODE_TREE,
    indpred PG_NODE_TREE
);
CREATE UNIQUE INDEX pg_index_indexrelid_index ON pg_index (indexrelid);
CREATE INDEX pg_index_indrelid_index ON pg_index (indrelid);
CREATE TABLE pg_inherits
(
    inhrelid OID NOT NULL,
    inhparent OID NOT NULL,
    inhseqno INTEGER NOT NULL
);
CREATE UNIQUE INDEX pg_inherits_relid_seqno_index ON pg_inherits (inhrelid, inhseqno);
CREATE INDEX pg_inherits_parent_index ON pg_inherits (inhparent);
CREATE TABLE pg_language
(
    lanname NAME NOT NULL,
    lanowner OID NOT NULL,
    lanispl BOOLEAN NOT NULL,
    lanpltrusted BOOLEAN NOT NULL,
    lanplcallfoid OID NOT NULL,
    laninline OID NOT NULL,
    lanvalidator OID NOT NULL,
    lanacl ACLITEM[]
);
CREATE UNIQUE INDEX pg_language_oid_index ON pg_language (oid);
CREATE UNIQUE INDEX pg_language_name_index ON pg_language (lanname);
CREATE TABLE pg_largeobject
(
    loid OID NOT NULL,
    pageno INTEGER NOT NULL,
    data BYTEA NOT NULL
);
CREATE UNIQUE INDEX pg_largeobject_loid_pn_index ON pg_largeobject (loid, pageno);
CREATE TABLE pg_largeobject_metadata
(
    lomowner OID NOT NULL,
    lomacl ACLITEM[]
);
CREATE UNIQUE INDEX pg_largeobject_metadata_oid_index ON pg_largeobject_metadata (oid);
CREATE TABLE pg_namespace
(
    nspname NAME NOT NULL,
    nspowner OID NOT NULL,
    nspacl ACLITEM[]
);
CREATE UNIQUE INDEX pg_namespace_oid_index ON pg_namespace (oid);
CREATE UNIQUE INDEX pg_namespace_nspname_index ON pg_namespace (nspname);
CREATE TABLE pg_opclass
(
    opcmethod OID NOT NULL,
    opcname NAME NOT NULL,
    opcnamespace OID NOT NULL,
    opcowner OID NOT NULL,
    opcfamily OID NOT NULL,
    opcintype OID NOT NULL,
    opcdefault BOOLEAN NOT NULL,
    opckeytype OID NOT NULL
);
CREATE UNIQUE INDEX pg_opclass_oid_index ON pg_opclass (oid);
CREATE UNIQUE INDEX pg_opclass_am_name_nsp_index ON pg_opclass (opcmethod, opcname, opcnamespace);
CREATE TABLE pg_operator
(
    oprname NAME NOT NULL,
    oprnamespace OID NOT NULL,
    oprowner OID NOT NULL,
    oprkind "char" NOT NULL,
    oprcanmerge BOOLEAN NOT NULL,
    oprcanhash BOOLEAN NOT NULL,
    oprleft OID NOT NULL,
    oprright OID NOT NULL,
    oprresult OID NOT NULL,
    oprcom OID NOT NULL,
    oprnegate OID NOT NULL,
    oprcode REGPROC NOT NULL,
    oprrest REGPROC NOT NULL,
    oprjoin REGPROC NOT NULL
);
CREATE UNIQUE INDEX pg_operator_oid_index ON pg_operator (oid);
CREATE UNIQUE INDEX pg_operator_oprname_l_r_n_index ON pg_operator (oprname, oprleft, oprright, oprnamespace);
CREATE TABLE pg_opfamily
(
    opfmethod OID NOT NULL,
    opfname NAME NOT NULL,
    opfnamespace OID NOT NULL,
    opfowner OID NOT NULL
);
CREATE UNIQUE INDEX pg_opfamily_oid_index ON pg_opfamily (oid);
CREATE UNIQUE INDEX pg_opfamily_am_name_nsp_index ON pg_opfamily (opfmethod, opfname, opfnamespace);
CREATE TABLE pg_pltemplate
(
    tmplname NAME NOT NULL,
    tmpltrusted BOOLEAN NOT NULL,
    tmpldbacreate BOOLEAN NOT NULL,
    tmplhandler TEXT NOT NULL,
    tmplinline TEXT,
    tmplvalidator TEXT,
    tmpllibrary TEXT NOT NULL,
    tmplacl ACLITEM[]
);
CREATE UNIQUE INDEX pg_pltemplate_name_index ON pg_pltemplate (tmplname);
CREATE TABLE pg_policy
(
    polname NAME NOT NULL,
    polrelid OID NOT NULL,
    polcmd "char" NOT NULL,
    polroles OID[],
    polqual PG_NODE_TREE,
    polwithcheck PG_NODE_TREE
);
CREATE UNIQUE INDEX pg_policy_oid_index ON pg_policy (oid);
CREATE UNIQUE INDEX pg_policy_polrelid_polname_index ON pg_policy (polrelid, polname);
CREATE TABLE pg_proc
(
    proname NAME NOT NULL,
    pronamespace OID NOT NULL,
    proowner OID NOT NULL,
    prolang OID NOT NULL,
    procost REAL NOT NULL,
    prorows REAL NOT NULL,
    provariadic OID NOT NULL,
    protransform REGPROC NOT NULL,
    proisagg BOOLEAN NOT NULL,
    proiswindow BOOLEAN NOT NULL,
    prosecdef BOOLEAN NOT NULL,
    proleakproof BOOLEAN NOT NULL,
    proisstrict BOOLEAN NOT NULL,
    proretset BOOLEAN NOT NULL,
    provolatile "char" NOT NULL,
    pronargs SMALLINT NOT NULL,
    pronargdefaults SMALLINT NOT NULL,
    prorettype OID NOT NULL,
    proargtypes OIDVECTOR NOT NULL,
    proallargtypes OID[],
    proargmodes "CHAR"[],
    proargnames TEXT[],
    proargdefaults PG_NODE_TREE,
    protrftypes OID[],
    prosrc TEXT NOT NULL,
    probin TEXT,
    proconfig TEXT[],
    proacl ACLITEM[]
);
CREATE UNIQUE INDEX pg_proc_oid_index ON pg_proc (oid);
CREATE UNIQUE INDEX pg_proc_proname_args_nsp_index ON pg_proc (proname, proargtypes, pronamespace);
CREATE TABLE pg_range
(
    rngtypid OID NOT NULL,
    rngsubtype OID NOT NULL,
    rngcollation OID NOT NULL,
    rngsubopc OID NOT NULL,
    rngcanonical REGPROC NOT NULL,
    rngsubdiff REGPROC NOT NULL
);
CREATE UNIQUE INDEX pg_range_rngtypid_index ON pg_range (rngtypid);
CREATE TABLE pg_replication_origin
(
    roident OID NOT NULL,
    roname TEXT NOT NULL
);
CREATE UNIQUE INDEX pg_replication_origin_roiident_index ON pg_replication_origin (roident);
CREATE UNIQUE INDEX pg_replication_origin_roname_index ON pg_replication_origin (roname);
CREATE TABLE pg_rewrite
(
    rulename NAME NOT NULL,
    ev_class OID NOT NULL,
    ev_type "char" NOT NULL,
    ev_enabled "char" NOT NULL,
    is_instead BOOLEAN NOT NULL,
    ev_qual PG_NODE_TREE,
    ev_action PG_NODE_TREE
);
CREATE UNIQUE INDEX pg_rewrite_oid_index ON pg_rewrite (oid);
CREATE UNIQUE INDEX pg_rewrite_rel_rulename_index ON pg_rewrite (ev_class, rulename);
CREATE TABLE pg_seclabel
(
    objoid OID NOT NULL,
    classoid OID NOT NULL,
    objsubid INTEGER NOT NULL,
    provider TEXT NOT NULL,
    label TEXT NOT NULL
);
CREATE UNIQUE INDEX pg_seclabel_object_index ON pg_seclabel (objoid, classoid, objsubid, provider);
CREATE TABLE pg_shdepend
(
    dbid OID NOT NULL,
    classid OID NOT NULL,
    objid OID NOT NULL,
    objsubid INTEGER NOT NULL,
    refclassid OID NOT NULL,
    refobjid OID NOT NULL,
    deptype "char" NOT NULL
);
CREATE INDEX pg_shdepend_depender_index ON pg_shdepend (dbid, classid, objid, objsubid);
CREATE INDEX pg_shdepend_reference_index ON pg_shdepend (refclassid, refobjid);
CREATE TABLE pg_shdescription
(
    objoid OID NOT NULL,
    classoid OID NOT NULL,
    description TEXT NOT NULL
);
CREATE UNIQUE INDEX pg_shdescription_o_c_index ON pg_shdescription (objoid, classoid);
CREATE TABLE pg_shseclabel
(
    objoid OID NOT NULL,
    classoid OID NOT NULL,
    provider TEXT NOT NULL,
    label TEXT NOT NULL
);
CREATE UNIQUE INDEX pg_shseclabel_object_index ON pg_shseclabel (objoid, classoid, provider);
CREATE TABLE pg_statistic
(
    starelid OID NOT NULL,
    staattnum SMALLINT NOT NULL,
    stainherit BOOLEAN NOT NULL,
    stanullfrac REAL NOT NULL,
    stawidth INTEGER NOT NULL,
    stadistinct REAL NOT NULL,
    stakind1 SMALLINT NOT NULL,
    stakind2 SMALLINT NOT NULL,
    stakind3 SMALLINT NOT NULL,
    stakind4 SMALLINT NOT NULL,
    stakind5 SMALLINT NOT NULL,
    staop1 OID NOT NULL,
    staop2 OID NOT NULL,
    staop3 OID NOT NULL,
    staop4 OID NOT NULL,
    staop5 OID NOT NULL,
    stanumbers1 REAL[],
    stanumbers2 REAL[],
    stanumbers3 REAL[],
    stanumbers4 REAL[],
    stanumbers5 REAL[],
    stavalues1 ANYARRAY,
    stavalues2 ANYARRAY,
    stavalues3 ANYARRAY,
    stavalues4 ANYARRAY,
    stavalues5 ANYARRAY
);
CREATE UNIQUE INDEX pg_statistic_relid_att_inh_index ON pg_statistic (starelid, staattnum, stainherit);
CREATE TABLE pg_tablespace
(
    spcname NAME NOT NULL,
    spcowner OID NOT NULL,
    spcacl ACLITEM[],
    spcoptions TEXT[]
);
CREATE UNIQUE INDEX pg_tablespace_oid_index ON pg_tablespace (oid);
CREATE UNIQUE INDEX pg_tablespace_spcname_index ON pg_tablespace (spcname);
CREATE TABLE pg_transform
(
    trftype OID NOT NULL,
    trflang OID NOT NULL,
    trffromsql REGPROC NOT NULL,
    trftosql REGPROC NOT NULL
);
CREATE UNIQUE INDEX pg_transform_oid_index ON pg_transform (oid);
CREATE UNIQUE INDEX pg_transform_type_lang_index ON pg_transform (trftype, trflang);
CREATE TABLE pg_trigger
(
    tgrelid OID NOT NULL,
    tgname NAME NOT NULL,
    tgfoid OID NOT NULL,
    tgtype SMALLINT NOT NULL,
    tgenabled "char" NOT NULL,
    tgisinternal BOOLEAN NOT NULL,
    tgconstrrelid OID NOT NULL,
    tgconstrindid OID NOT NULL,
    tgconstraint OID NOT NULL,
    tgdeferrable BOOLEAN NOT NULL,
    tginitdeferred BOOLEAN NOT NULL,
    tgnargs SMALLINT NOT NULL,
    tgattr INT2VECTOR NOT NULL,
    tgargs BYTEA NOT NULL,
    tgqual PG_NODE_TREE
);
CREATE UNIQUE INDEX pg_trigger_oid_index ON pg_trigger (oid);
CREATE UNIQUE INDEX pg_trigger_tgrelid_tgname_index ON pg_trigger (tgrelid, tgname);
CREATE INDEX pg_trigger_tgconstraint_index ON pg_trigger (tgconstraint);
CREATE TABLE pg_ts_config
(
    cfgname NAME NOT NULL,
    cfgnamespace OID NOT NULL,
    cfgowner OID NOT NULL,
    cfgparser OID NOT NULL
);
CREATE UNIQUE INDEX pg_ts_config_oid_index ON pg_ts_config (oid);
CREATE UNIQUE INDEX pg_ts_config_cfgname_index ON pg_ts_config (cfgname, cfgnamespace);
CREATE TABLE pg_ts_config_map
(
    mapcfg OID NOT NULL,
    maptokentype INTEGER NOT NULL,
    mapseqno INTEGER NOT NULL,
    mapdict OID NOT NULL
);
CREATE UNIQUE INDEX pg_ts_config_map_index ON pg_ts_config_map (mapcfg, maptokentype, mapseqno);
CREATE TABLE pg_ts_dict
(
    dictname NAME NOT NULL,
    dictnamespace OID NOT NULL,
    dictowner OID NOT NULL,
    dicttemplate OID NOT NULL,
    dictinitoption TEXT
);
CREATE UNIQUE INDEX pg_ts_dict_oid_index ON pg_ts_dict (oid);
CREATE UNIQUE INDEX pg_ts_dict_dictname_index ON pg_ts_dict (dictname, dictnamespace);
CREATE TABLE pg_ts_parser
(
    prsname NAME NOT NULL,
    prsnamespace OID NOT NULL,
    prsstart REGPROC NOT NULL,
    prstoken REGPROC NOT NULL,
    prsend REGPROC NOT NULL,
    prsheadline REGPROC NOT NULL,
    prslextype REGPROC NOT NULL
);
CREATE UNIQUE INDEX pg_ts_parser_oid_index ON pg_ts_parser (oid);
CREATE UNIQUE INDEX pg_ts_parser_prsname_index ON pg_ts_parser (prsname, prsnamespace);
CREATE TABLE pg_ts_template
(
    tmplname NAME NOT NULL,
    tmplnamespace OID NOT NULL,
    tmplinit REGPROC NOT NULL,
    tmpllexize REGPROC NOT NULL
);
CREATE UNIQUE INDEX pg_ts_template_oid_index ON pg_ts_template (oid);
CREATE UNIQUE INDEX pg_ts_template_tmplname_index ON pg_ts_template (tmplname, tmplnamespace);
CREATE TABLE pg_type
(
    typname NAME NOT NULL,
    typnamespace OID NOT NULL,
    typowner OID NOT NULL,
    typlen SMALLINT NOT NULL,
    typbyval BOOLEAN NOT NULL,
    typtype "char" NOT NULL,
    typcategory "char" NOT NULL,
    typispreferred BOOLEAN NOT NULL,
    typisdefined BOOLEAN NOT NULL,
    typdelim "char" NOT NULL,
    typrelid OID NOT NULL,
    typelem OID NOT NULL,
    typarray OID NOT NULL,
    typinput REGPROC NOT NULL,
    typoutput REGPROC NOT NULL,
    typreceive REGPROC NOT NULL,
    typsend REGPROC NOT NULL,
    typmodin REGPROC NOT NULL,
    typmodout REGPROC NOT NULL,
    typanalyze REGPROC NOT NULL,
    typalign "char" NOT NULL,
    typstorage "char" NOT NULL,
    typnotnull BOOLEAN NOT NULL,
    typbasetype OID NOT NULL,
    typtypmod INTEGER NOT NULL,
    typndims INTEGER NOT NULL,
    typcollation OID NOT NULL,
    typdefaultbin PG_NODE_TREE,
    typdefault TEXT,
    typacl ACLITEM[]
);
CREATE UNIQUE INDEX pg_type_oid_index ON pg_type (oid);
CREATE UNIQUE INDEX pg_type_typname_nsp_index ON pg_type (typname, typnamespace);
CREATE TABLE pg_user_mapping
(
    umuser OID NOT NULL,
    umserver OID NOT NULL,
    umoptions TEXT[]
);
CREATE UNIQUE INDEX pg_user_mapping_oid_index ON pg_user_mapping (oid);
CREATE UNIQUE INDEX pg_user_mapping_user_server_index ON pg_user_mapping (umuser, umserver);
CREATE TABLE pg_available_extension_versions
(
    name NAME,
    version TEXT,
    installed BOOLEAN,
    superuser BOOLEAN,
    relocatable BOOLEAN,
    schema NAME,
    requires NAME[],
    comment TEXT
);
CREATE TABLE pg_available_extensions
(
    name NAME,
    default_version TEXT,
    installed_version TEXT,
    comment TEXT
);
CREATE TABLE pg_cursors
(
    name TEXT,
    statement TEXT,
    is_holdable BOOLEAN,
    is_binary BOOLEAN,
    is_scrollable BOOLEAN,
    creation_time TIMESTAMP WITH TIME ZONE
);
CREATE TABLE pg_file_settings
(
    sourcefile TEXT,
    sourceline INTEGER,
    seqno INTEGER,
    name TEXT,
    setting TEXT,
    applied BOOLEAN,
    error TEXT
);
CREATE TABLE pg_group
(
    groname NAME,
    grosysid OID,
    grolist OID[]
);
CREATE TABLE pg_indexes
(
    schemaname NAME,
    tablename NAME,
    indexname NAME,
    tablespace NAME,
    indexdef TEXT
);
CREATE TABLE pg_locks
(
    locktype TEXT,
    database OID,
    relation OID,
    page INTEGER,
    tuple SMALLINT,
    virtualxid TEXT,
    transactionid XID,
    classid OID,
    objid OID,
    objsubid SMALLINT,
    virtualtransaction TEXT,
    pid INTEGER,
    mode TEXT,
    granted BOOLEAN,
    fastpath BOOLEAN
);
CREATE TABLE pg_matviews
(
    schemaname NAME,
    matviewname NAME,
    matviewowner NAME,
    tablespace NAME,
    hasindexes BOOLEAN,
    ispopulated BOOLEAN,
    definition TEXT
);
CREATE TABLE pg_policies
(
    schemaname NAME,
    tablename NAME,
    policyname NAME,
    roles NAME[],
    cmd TEXT,
    qual TEXT,
    with_check TEXT
);
CREATE TABLE pg_prepared_statements
(
    name TEXT,
    statement TEXT,
    prepare_time TIMESTAMP WITH TIME ZONE,
    parameter_types REGTYPE[],
    from_sql BOOLEAN
);
CREATE TABLE pg_prepared_xacts
(
    transaction XID,
    gid TEXT,
    prepared TIMESTAMP WITH TIME ZONE,
    owner NAME,
    database NAME
);
CREATE TABLE pg_replication_origin_status
(
    local_id OID,
    external_id TEXT,
    remote_lsn PG_LSN,
    local_lsn PG_LSN
);
CREATE TABLE pg_replication_slots
(
    slot_name NAME,
    plugin NAME,
    slot_type TEXT,
    datoid OID,
    database NAME,
    active BOOLEAN,
    active_pid INTEGER,
    xmin XID,
    catalog_xmin XID,
    restart_lsn PG_LSN
);
CREATE TABLE pg_roles
(
    rolname NAME,
    rolsuper BOOLEAN,
    rolinherit BOOLEAN,
    rolcreaterole BOOLEAN,
    rolcreatedb BOOLEAN,
    rolcanlogin BOOLEAN,
    rolreplication BOOLEAN,
    rolconnlimit INTEGER,
    rolpassword TEXT,
    rolvaliduntil TIMESTAMP WITH TIME ZONE,
    rolbypassrls BOOLEAN,
    rolconfig TEXT[],
    oid OID
);
CREATE TABLE pg_rules
(
    schemaname NAME,
    tablename NAME,
    rulename NAME,
    definition TEXT
);
CREATE TABLE pg_seclabels
(
    objoid OID,
    classoid OID,
    objsubid INTEGER,
    objtype TEXT,
    objnamespace OID,
    objname TEXT,
    provider TEXT,
    label TEXT
);
CREATE TABLE pg_settings
(
    name TEXT,
    setting TEXT,
    unit TEXT,
    category TEXT,
    short_desc TEXT,
    extra_desc TEXT,
    context TEXT,
    vartype TEXT,
    source TEXT,
    min_val TEXT,
    max_val TEXT,
    enumvals TEXT[],
    boot_val TEXT,
    reset_val TEXT,
    sourcefile TEXT,
    sourceline INTEGER,
    pending_restart BOOLEAN
);
CREATE TABLE pg_shadow
(
    usename NAME,
    usesysid OID,
    usecreatedb BOOLEAN,
    usesuper BOOLEAN,
    userepl BOOLEAN,
    usebypassrls BOOLEAN,
    passwd TEXT,
    valuntil ABSTIME,
    useconfig TEXT[]
);
CREATE TABLE pg_stat_activity
(
    datid OID,
    datname NAME,
    pid INTEGER,
    usesysid OID,
    usename NAME,
    application_name TEXT,
    client_addr INET,
    client_hostname TEXT,
    client_port INTEGER,
    backend_start TIMESTAMP WITH TIME ZONE,
    xact_start TIMESTAMP WITH TIME ZONE,
    query_start TIMESTAMP WITH TIME ZONE,
    state_change TIMESTAMP WITH TIME ZONE,
    waiting BOOLEAN,
    state TEXT,
    backend_xid XID,
    backend_xmin XID,
    query TEXT
);
CREATE TABLE pg_stat_all_indexes
(
    relid OID,
    indexrelid OID,
    schemaname NAME,
    relname NAME,
    indexrelname NAME,
    idx_scan BIGINT,
    idx_tup_read BIGINT,
    idx_tup_fetch BIGINT
);
CREATE TABLE pg_stat_all_tables
(
    relid OID,
    schemaname NAME,
    relname NAME,
    seq_scan BIGINT,
    seq_tup_read BIGINT,
    idx_scan BIGINT,
    idx_tup_fetch BIGINT,
    n_tup_ins BIGINT,
    n_tup_upd BIGINT,
    n_tup_del BIGINT,
    n_tup_hot_upd BIGINT,
    n_live_tup BIGINT,
    n_dead_tup BIGINT,
    n_mod_since_analyze BIGINT,
    last_vacuum TIMESTAMP WITH TIME ZONE,
    last_autovacuum TIMESTAMP WITH TIME ZONE,
    last_analyze TIMESTAMP WITH TIME ZONE,
    last_autoanalyze TIMESTAMP WITH TIME ZONE,
    vacuum_count BIGINT,
    autovacuum_count BIGINT,
    analyze_count BIGINT,
    autoanalyze_count BIGINT
);
CREATE TABLE pg_stat_archiver
(
    archived_count BIGINT,
    last_archived_wal TEXT,
    last_archived_time TIMESTAMP WITH TIME ZONE,
    failed_count BIGINT,
    last_failed_wal TEXT,
    last_failed_time TIMESTAMP WITH TIME ZONE,
    stats_reset TIMESTAMP WITH TIME ZONE
);
CREATE TABLE pg_stat_bgwriter
(
    checkpoints_timed BIGINT,
    checkpoints_req BIGINT,
    checkpoint_write_time DOUBLE PRECISION,
    checkpoint_sync_time DOUBLE PRECISION,
    buffers_checkpoint BIGINT,
    buffers_clean BIGINT,
    maxwritten_clean BIGINT,
    buffers_backend BIGINT,
    buffers_backend_fsync BIGINT,
    buffers_alloc BIGINT,
    stats_reset TIMESTAMP WITH TIME ZONE
);
CREATE TABLE pg_stat_database
(
    datid OID,
    datname NAME,
    numbackends INTEGER,
    xact_commit BIGINT,
    xact_rollback BIGINT,
    blks_read BIGINT,
    blks_hit BIGINT,
    tup_returned BIGINT,
    tup_fetched BIGINT,
    tup_inserted BIGINT,
    tup_updated BIGINT,
    tup_deleted BIGINT,
    conflicts BIGINT,
    temp_files BIGINT,
    temp_bytes BIGINT,
    deadlocks BIGINT,
    blk_read_time DOUBLE PRECISION,
    blk_write_time DOUBLE PRECISION,
    stats_reset TIMESTAMP WITH TIME ZONE
);
CREATE TABLE pg_stat_database_conflicts
(
    datid OID,
    datname NAME,
    confl_tablespace BIGINT,
    confl_lock BIGINT,
    confl_snapshot BIGINT,
    confl_bufferpin BIGINT,
    confl_deadlock BIGINT
);
CREATE TABLE pg_stat_replication
(
    pid INTEGER,
    usesysid OID,
    usename NAME,
    application_name TEXT,
    client_addr INET,
    client_hostname TEXT,
    client_port INTEGER,
    backend_start TIMESTAMP WITH TIME ZONE,
    backend_xmin XID,
    state TEXT,
    sent_location PG_LSN,
    write_location PG_LSN,
    flush_location PG_LSN,
    replay_location PG_LSN,
    sync_priority INTEGER,
    sync_state TEXT
);
CREATE TABLE pg_stat_ssl
(
    pid INTEGER,
    ssl BOOLEAN,
    version TEXT,
    cipher TEXT,
    bits INTEGER,
    compression BOOLEAN,
    clientdn TEXT
);
CREATE TABLE pg_stat_sys_indexes
(
    relid OID,
    indexrelid OID,
    schemaname NAME,
    relname NAME,
    indexrelname NAME,
    idx_scan BIGINT,
    idx_tup_read BIGINT,
    idx_tup_fetch BIGINT
);
CREATE TABLE pg_stat_sys_tables
(
    relid OID,
    schemaname NAME,
    relname NAME,
    seq_scan BIGINT,
    seq_tup_read BIGINT,
    idx_scan BIGINT,
    idx_tup_fetch BIGINT,
    n_tup_ins BIGINT,
    n_tup_upd BIGINT,
    n_tup_del BIGINT,
    n_tup_hot_upd BIGINT,
    n_live_tup BIGINT,
    n_dead_tup BIGINT,
    n_mod_since_analyze BIGINT,
    last_vacuum TIMESTAMP WITH TIME ZONE,
    last_autovacuum TIMESTAMP WITH TIME ZONE,
    last_analyze TIMESTAMP WITH TIME ZONE,
    last_autoanalyze TIMESTAMP WITH TIME ZONE,
    vacuum_count BIGINT,
    autovacuum_count BIGINT,
    analyze_count BIGINT,
    autoanalyze_count BIGINT
);
CREATE TABLE pg_stat_user_functions
(
    funcid OID,
    schemaname NAME,
    funcname NAME,
    calls BIGINT,
    total_time DOUBLE PRECISION,
    self_time DOUBLE PRECISION
);
CREATE TABLE pg_stat_user_indexes
(
    relid OID,
    indexrelid OID,
    schemaname NAME,
    relname NAME,
    indexrelname NAME,
    idx_scan BIGINT,
    idx_tup_read BIGINT,
    idx_tup_fetch BIGINT
);
CREATE TABLE pg_stat_user_tables
(
    relid OID,
    schemaname NAME,
    relname NAME,
    seq_scan BIGINT,
    seq_tup_read BIGINT,
    idx_scan BIGINT,
    idx_tup_fetch BIGINT,
    n_tup_ins BIGINT,
    n_tup_upd BIGINT,
    n_tup_del BIGINT,
    n_tup_hot_upd BIGINT,
    n_live_tup BIGINT,
    n_dead_tup BIGINT,
    n_mod_since_analyze BIGINT,
    last_vacuum TIMESTAMP WITH TIME ZONE,
    last_autovacuum TIMESTAMP WITH TIME ZONE,
    last_analyze TIMESTAMP WITH TIME ZONE,
    last_autoanalyze TIMESTAMP WITH TIME ZONE,
    vacuum_count BIGINT,
    autovacuum_count BIGINT,
    analyze_count BIGINT,
    autoanalyze_count BIGINT
);
CREATE TABLE pg_stat_xact_all_tables
(
    relid OID,
    schemaname NAME,
    relname NAME,
    seq_scan BIGINT,
    seq_tup_read BIGINT,
    idx_scan BIGINT,
    idx_tup_fetch BIGINT,
    n_tup_ins BIGINT,
    n_tup_upd BIGINT,
    n_tup_del BIGINT,
    n_tup_hot_upd BIGINT
);
CREATE TABLE pg_stat_xact_sys_tables
(
    relid OID,
    schemaname NAME,
    relname NAME,
    seq_scan BIGINT,
    seq_tup_read BIGINT,
    idx_scan BIGINT,
    idx_tup_fetch BIGINT,
    n_tup_ins BIGINT,
    n_tup_upd BIGINT,
    n_tup_del BIGINT,
    n_tup_hot_upd BIGINT
);
CREATE TABLE pg_stat_xact_user_functions
(
    funcid OID,
    schemaname NAME,
    funcname NAME,
    calls BIGINT,
    total_time DOUBLE PRECISION,
    self_time DOUBLE PRECISION
);
CREATE TABLE pg_stat_xact_user_tables
(
    relid OID,
    schemaname NAME,
    relname NAME,
    seq_scan BIGINT,
    seq_tup_read BIGINT,
    idx_scan BIGINT,
    idx_tup_fetch BIGINT,
    n_tup_ins BIGINT,
    n_tup_upd BIGINT,
    n_tup_del BIGINT,
    n_tup_hot_upd BIGINT
);
CREATE TABLE pg_statio_all_indexes
(
    relid OID,
    indexrelid OID,
    schemaname NAME,
    relname NAME,
    indexrelname NAME,
    idx_blks_read BIGINT,
    idx_blks_hit BIGINT
);
CREATE TABLE pg_statio_all_sequences
(
    relid OID,
    schemaname NAME,
    relname NAME,
    blks_read BIGINT,
    blks_hit BIGINT
);
CREATE TABLE pg_statio_all_tables
(
    relid OID,
    schemaname NAME,
    relname NAME,
    heap_blks_read BIGINT,
    heap_blks_hit BIGINT,
    idx_blks_read BIGINT,
    idx_blks_hit BIGINT,
    toast_blks_read BIGINT,
    toast_blks_hit BIGINT,
    tidx_blks_read BIGINT,
    tidx_blks_hit BIGINT
);
CREATE TABLE pg_statio_sys_indexes
(
    relid OID,
    indexrelid OID,
    schemaname NAME,
    relname NAME,
    indexrelname NAME,
    idx_blks_read BIGINT,
    idx_blks_hit BIGINT
);
CREATE TABLE pg_statio_sys_sequences
(
    relid OID,
    schemaname NAME,
    relname NAME,
    blks_read BIGINT,
    blks_hit BIGINT
);
CREATE TABLE pg_statio_sys_tables
(
    relid OID,
    schemaname NAME,
    relname NAME,
    heap_blks_read BIGINT,
    heap_blks_hit BIGINT,
    idx_blks_read BIGINT,
    idx_blks_hit BIGINT,
    toast_blks_read BIGINT,
    toast_blks_hit BIGINT,
    tidx_blks_read BIGINT,
    tidx_blks_hit BIGINT
);
CREATE TABLE pg_statio_user_indexes
(
    relid OID,
    indexrelid OID,
    schemaname NAME,
    relname NAME,
    indexrelname NAME,
    idx_blks_read BIGINT,
    idx_blks_hit BIGINT
);
CREATE TABLE pg_statio_user_sequences
(
    relid OID,
    schemaname NAME,
    relname NAME,
    blks_read BIGINT,
    blks_hit BIGINT
);
CREATE TABLE pg_statio_user_tables
(
    relid OID,
    schemaname NAME,
    relname NAME,
    heap_blks_read BIGINT,
    heap_blks_hit BIGINT,
    idx_blks_read BIGINT,
    idx_blks_hit BIGINT,
    toast_blks_read BIGINT,
    toast_blks_hit BIGINT,
    tidx_blks_read BIGINT,
    tidx_blks_hit BIGINT
);
CREATE TABLE pg_stats
(
    schemaname NAME,
    tablename NAME,
    attname NAME,
    inherited BOOLEAN,
    null_frac REAL,
    avg_width INTEGER,
    n_distinct REAL,
    most_common_vals ANYARRAY,
    most_common_freqs REAL[],
    histogram_bounds ANYARRAY,
    correlation REAL,
    most_common_elems ANYARRAY,
    most_common_elem_freqs REAL[],
    elem_count_histogram REAL[]
);
CREATE TABLE pg_tables
(
    schemaname NAME,
    tablename NAME,
    tableowner NAME,
    tablespace NAME,
    hasindexes BOOLEAN,
    hasrules BOOLEAN,
    hastriggers BOOLEAN,
    rowsecurity BOOLEAN
);
CREATE TABLE pg_timezone_abbrevs
(
    abbrev TEXT,
    utc_offset INTERVAL,
    is_dst BOOLEAN
);
CREATE TABLE pg_timezone_names
(
    name TEXT,
    abbrev TEXT,
    utc_offset INTERVAL,
    is_dst BOOLEAN
);
CREATE TABLE pg_user
(
    usename NAME,
    usesysid OID,
    usecreatedb BOOLEAN,
    usesuper BOOLEAN,
    userepl BOOLEAN,
    usebypassrls BOOLEAN,
    passwd TEXT,
    valuntil ABSTIME,
    useconfig TEXT[]
);
CREATE TABLE pg_user_mappings
(
    umid OID,
    srvid OID,
    srvname NAME,
    umuser OID,
    usename NAME,
    umoptions TEXT[]
);
CREATE TABLE pg_views
(
    schemaname NAME,
    viewname NAME,
    viewowner NAME,
    definition TEXT
);
CREATE FUNCTION "RI_FKey_cascade_del"() RETURNS TRIGGER;
CREATE FUNCTION "RI_FKey_cascade_upd"() RETURNS TRIGGER;
CREATE FUNCTION "RI_FKey_check_ins"() RETURNS TRIGGER;
CREATE FUNCTION "RI_FKey_check_upd"() RETURNS TRIGGER;
CREATE FUNCTION "RI_FKey_noaction_del"() RETURNS TRIGGER;
CREATE FUNCTION "RI_FKey_noaction_upd"() RETURNS TRIGGER;
CREATE FUNCTION "RI_FKey_restrict_del"() RETURNS TRIGGER;
CREATE FUNCTION "RI_FKey_restrict_upd"() RETURNS TRIGGER;
CREATE FUNCTION "RI_FKey_setdefault_del"() RETURNS TRIGGER;
CREATE FUNCTION "RI_FKey_setdefault_upd"() RETURNS TRIGGER;
CREATE FUNCTION "RI_FKey_setnull_del"() RETURNS TRIGGER;
CREATE FUNCTION "RI_FKey_setnull_upd"() RETURNS TRIGGER;
CREATE FUNCTION abbrev(CIDR) RETURNS TEXT;
CREATE FUNCTION abbrev(INET) RETURNS TEXT;
CREATE FUNCTION abs(BIGINT) RETURNS BIGINT;
CREATE FUNCTION abs(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION abs(INTEGER) RETURNS INTEGER;
CREATE FUNCTION abs(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION abs(REAL) RETURNS REAL;
CREATE FUNCTION abs(SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION abstime(TIMESTAMP WITH TIME ZONE) RETURNS ABSTIME;
CREATE FUNCTION abstime(TIMESTAMP) RETURNS ABSTIME;
CREATE FUNCTION abstimeeq(ABSTIME, ABSTIME) RETURNS BOOLEAN;
CREATE FUNCTION abstimege(ABSTIME, ABSTIME) RETURNS BOOLEAN;
CREATE FUNCTION abstimegt(ABSTIME, ABSTIME) RETURNS BOOLEAN;
CREATE FUNCTION abstimein(CSTRING) RETURNS ABSTIME;
CREATE FUNCTION abstimele(ABSTIME, ABSTIME) RETURNS BOOLEAN;
CREATE FUNCTION abstimelt(ABSTIME, ABSTIME) RETURNS BOOLEAN;
CREATE FUNCTION abstimene(ABSTIME, ABSTIME) RETURNS BOOLEAN;
CREATE FUNCTION abstimeout(ABSTIME) RETURNS CSTRING;
CREATE FUNCTION abstimerecv(INTERNAL) RETURNS ABSTIME;
CREATE FUNCTION abstimesend(ABSTIME) RETURNS BYTEA;
CREATE FUNCTION aclcontains(ACLITEM[], ACLITEM) RETURNS BOOLEAN;
CREATE FUNCTION acldefault("char", OID) RETURNS ACLITEM[];
CREATE FUNCTION aclexplode(acl ACLITEM[], grantor OUT OID, grantee OUT OID, privilege_type OUT TEXT, is_grantable OUT BOOLEAN) RETURNS SETOF RECORD;
CREATE FUNCTION aclinsert(ACLITEM[], ACLITEM) RETURNS ACLITEM[];
CREATE FUNCTION aclitemeq(ACLITEM, ACLITEM) RETURNS BOOLEAN;
CREATE FUNCTION aclitemin(CSTRING) RETURNS ACLITEM;
CREATE FUNCTION aclitemout(ACLITEM) RETURNS CSTRING;
CREATE FUNCTION aclremove(ACLITEM[], ACLITEM) RETURNS ACLITEM[];
CREATE FUNCTION acos(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION age(TIMESTAMP WITH TIME ZONE) RETURNS INTERVAL;
CREATE FUNCTION age(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) RETURNS INTERVAL;
CREATE FUNCTION age(TIMESTAMP) RETURNS INTERVAL;
CREATE FUNCTION age(TIMESTAMP, TIMESTAMP) RETURNS INTERVAL;
CREATE FUNCTION age(XID) RETURNS INTEGER;
CREATE FUNCTION any_in(CSTRING) RETURNS "any";
CREATE FUNCTION any_out("any") RETURNS CSTRING;
CREATE FUNCTION anyarray_in(CSTRING) RETURNS ANYARRAY;
CREATE FUNCTION anyarray_out(ANYARRAY) RETURNS CSTRING;
CREATE FUNCTION anyarray_recv(INTERNAL) RETURNS ANYARRAY;
CREATE FUNCTION anyarray_send(ANYARRAY) RETURNS BYTEA;
CREATE FUNCTION anyelement_in(CSTRING) RETURNS ANYELEMENT;
CREATE FUNCTION anyelement_out(ANYELEMENT) RETURNS CSTRING;
CREATE FUNCTION anyenum_in(CSTRING) RETURNS ANYENUM;
CREATE FUNCTION anyenum_out(ANYENUM) RETURNS CSTRING;
CREATE FUNCTION anynonarray_in(CSTRING) RETURNS ANYNONARRAY;
CREATE FUNCTION anynonarray_out(ANYNONARRAY) RETURNS CSTRING;
CREATE FUNCTION anyrange_in(CSTRING, OID, INTEGER) RETURNS ANYRANGE;
CREATE FUNCTION anyrange_out(ANYRANGE) RETURNS CSTRING;
CREATE FUNCTION anytextcat(ANYNONARRAY, TEXT) RETURNS TEXT;
CREATE FUNCTION area(BOX) RETURNS DOUBLE PRECISION;
CREATE FUNCTION area(CIRCLE) RETURNS DOUBLE PRECISION;
CREATE FUNCTION area(PATH) RETURNS DOUBLE PRECISION;
CREATE FUNCTION areajoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION areasel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION array_agg(ANYARRAY) RETURNS ANYARRAY;
CREATE FUNCTION array_agg(ANYNONARRAY) RETURNS ANYARRAY;
CREATE FUNCTION array_agg_array_finalfn(INTERNAL, ANYARRAY) RETURNS ANYARRAY;
CREATE FUNCTION array_agg_array_transfn(INTERNAL, ANYARRAY) RETURNS INTERNAL;
CREATE FUNCTION array_agg_finalfn(INTERNAL, ANYNONARRAY) RETURNS ANYARRAY;
CREATE FUNCTION array_agg_transfn(INTERNAL, ANYNONARRAY) RETURNS INTERNAL;
CREATE FUNCTION array_append(ANYARRAY, ANYELEMENT) RETURNS ANYARRAY;
CREATE FUNCTION array_cat(ANYARRAY, ANYARRAY) RETURNS ANYARRAY;
CREATE FUNCTION array_dims(ANYARRAY) RETURNS TEXT;
CREATE FUNCTION array_eq(ANYARRAY, ANYARRAY) RETURNS BOOLEAN;
CREATE FUNCTION array_fill(ANYELEMENT, INTEGER[]) RETURNS ANYARRAY;
CREATE FUNCTION array_fill(ANYELEMENT, INTEGER[], INTEGER[]) RETURNS ANYARRAY;
CREATE FUNCTION array_ge(ANYARRAY, ANYARRAY) RETURNS BOOLEAN;
CREATE FUNCTION array_gt(ANYARRAY, ANYARRAY) RETURNS BOOLEAN;
CREATE FUNCTION array_in(CSTRING, OID, INTEGER) RETURNS ANYARRAY;
CREATE FUNCTION array_larger(ANYARRAY, ANYARRAY) RETURNS ANYARRAY;
CREATE FUNCTION array_le(ANYARRAY, ANYARRAY) RETURNS BOOLEAN;
CREATE FUNCTION array_length(ANYARRAY, INTEGER) RETURNS INTEGER;
CREATE FUNCTION array_lower(ANYARRAY, INTEGER) RETURNS INTEGER;
CREATE FUNCTION array_lt(ANYARRAY, ANYARRAY) RETURNS BOOLEAN;
CREATE FUNCTION array_ndims(ANYARRAY) RETURNS INTEGER;
CREATE FUNCTION array_ne(ANYARRAY, ANYARRAY) RETURNS BOOLEAN;
CREATE FUNCTION array_out(ANYARRAY) RETURNS CSTRING;
CREATE FUNCTION array_position(ANYARRAY, ANYELEMENT) RETURNS INTEGER;
CREATE FUNCTION array_position(ANYARRAY, ANYELEMENT, INTEGER) RETURNS INTEGER;
CREATE FUNCTION array_positions(ANYARRAY, ANYELEMENT) RETURNS INTEGER[];
CREATE FUNCTION array_prepend(ANYELEMENT, ANYARRAY) RETURNS ANYARRAY;
CREATE FUNCTION array_recv(INTERNAL, OID, INTEGER) RETURNS ANYARRAY;
CREATE FUNCTION array_remove(ANYARRAY, ANYELEMENT) RETURNS ANYARRAY;
CREATE FUNCTION array_replace(ANYARRAY, ANYELEMENT, ANYELEMENT) RETURNS ANYARRAY;
CREATE FUNCTION array_send(ANYARRAY) RETURNS BYTEA;
CREATE FUNCTION array_smaller(ANYARRAY, ANYARRAY) RETURNS ANYARRAY;
CREATE FUNCTION array_to_json(ANYARRAY) RETURNS JSON;
CREATE FUNCTION array_to_json(ANYARRAY, BOOLEAN) RETURNS JSON;
CREATE FUNCTION array_to_string(ANYARRAY, TEXT) RETURNS TEXT;
CREATE FUNCTION array_to_string(ANYARRAY, TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION array_typanalyze(INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION array_upper(ANYARRAY, INTEGER) RETURNS INTEGER;
CREATE FUNCTION arraycontained(ANYARRAY, ANYARRAY) RETURNS BOOLEAN;
CREATE FUNCTION arraycontains(ANYARRAY, ANYARRAY) RETURNS BOOLEAN;
CREATE FUNCTION arraycontjoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION arraycontsel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION arrayoverlap(ANYARRAY, ANYARRAY) RETURNS BOOLEAN;
CREATE FUNCTION ascii(TEXT) RETURNS INTEGER;
CREATE FUNCTION ascii_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION ascii_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION asin(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION atan(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION atan2(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION avg(BIGINT) RETURNS NUMERIC;
CREATE FUNCTION avg(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION avg(INTEGER) RETURNS NUMERIC;
CREATE FUNCTION avg(INTERVAL) RETURNS INTERVAL;
CREATE FUNCTION avg(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION avg(REAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION avg(SMALLINT) RETURNS NUMERIC;
CREATE FUNCTION bernoulli(INTERNAL) RETURNS TSM_HANDLER;
CREATE FUNCTION big5_to_euc_tw(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION big5_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION big5_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION binary_upgrade_create_empty_extension(TEXT, TEXT, BOOLEAN, TEXT, OID[], TEXT[], TEXT[]) RETURNS VOID;
CREATE FUNCTION binary_upgrade_set_next_array_pg_type_oid(OID) RETURNS VOID;
CREATE FUNCTION binary_upgrade_set_next_heap_pg_class_oid(OID) RETURNS VOID;
CREATE FUNCTION binary_upgrade_set_next_index_pg_class_oid(OID) RETURNS VOID;
CREATE FUNCTION binary_upgrade_set_next_pg_authid_oid(OID) RETURNS VOID;
CREATE FUNCTION binary_upgrade_set_next_pg_enum_oid(OID) RETURNS VOID;
CREATE FUNCTION binary_upgrade_set_next_pg_type_oid(OID) RETURNS VOID;
CREATE FUNCTION binary_upgrade_set_next_toast_pg_class_oid(OID) RETURNS VOID;
CREATE FUNCTION binary_upgrade_set_next_toast_pg_type_oid(OID) RETURNS VOID;
CREATE FUNCTION bit(BIGINT, INTEGER) RETURNS BIT;
CREATE FUNCTION bit(BIT, INTEGER, BOOLEAN) RETURNS BIT;
CREATE FUNCTION bit(INTEGER, INTEGER) RETURNS BIT;
CREATE FUNCTION bit_and(BIGINT) RETURNS BIGINT;
CREATE FUNCTION bit_and(BIT) RETURNS BIT;
CREATE FUNCTION bit_and(INTEGER) RETURNS INTEGER;
CREATE FUNCTION bit_and(SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION bit_in(CSTRING, OID, INTEGER) RETURNS BIT;
CREATE FUNCTION bit_length(BIT) RETURNS INTEGER;
CREATE FUNCTION bit_length(BYTEA) RETURNS INTEGER;
CREATE FUNCTION bit_length(TEXT) RETURNS INTEGER;
CREATE FUNCTION bit_or(BIGINT) RETURNS BIGINT;
CREATE FUNCTION bit_or(BIT) RETURNS BIT;
CREATE FUNCTION bit_or(INTEGER) RETURNS INTEGER;
CREATE FUNCTION bit_or(SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION bit_out(BIT) RETURNS CSTRING;
CREATE FUNCTION bit_recv(INTERNAL, OID, INTEGER) RETURNS BIT;
CREATE FUNCTION bit_send(BIT) RETURNS BYTEA;
CREATE FUNCTION bitand(BIT, BIT) RETURNS BIT;
CREATE FUNCTION bitcat(BIT VARYING, BIT VARYING) RETURNS BIT VARYING;
CREATE FUNCTION bitcmp(BIT, BIT) RETURNS INTEGER;
CREATE FUNCTION biteq(BIT, BIT) RETURNS BOOLEAN;
CREATE FUNCTION bitge(BIT, BIT) RETURNS BOOLEAN;
CREATE FUNCTION bitgt(BIT, BIT) RETURNS BOOLEAN;
CREATE FUNCTION bitle(BIT, BIT) RETURNS BOOLEAN;
CREATE FUNCTION bitlt(BIT, BIT) RETURNS BOOLEAN;
CREATE FUNCTION bitne(BIT, BIT) RETURNS BOOLEAN;
CREATE FUNCTION bitnot(BIT) RETURNS BIT;
CREATE FUNCTION bitor(BIT, BIT) RETURNS BIT;
CREATE FUNCTION bitshiftleft(BIT, INTEGER) RETURNS BIT;
CREATE FUNCTION bitshiftright(BIT, INTEGER) RETURNS BIT;
CREATE FUNCTION bittypmodin(CSTRING[]) RETURNS INTEGER;
CREATE FUNCTION bittypmodout(INTEGER) RETURNS CSTRING;
CREATE FUNCTION bitxor(BIT, BIT) RETURNS BIT;
CREATE FUNCTION bool(INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION bool_accum(INTERNAL, BOOLEAN) RETURNS INTERNAL;
CREATE FUNCTION bool_accum_inv(INTERNAL, BOOLEAN) RETURNS INTERNAL;
CREATE FUNCTION bool_alltrue(INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION bool_and(BOOLEAN) RETURNS BOOLEAN;
CREATE FUNCTION bool_anytrue(INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION bool_or(BOOLEAN) RETURNS BOOLEAN;
CREATE FUNCTION booland_statefunc(BOOLEAN, BOOLEAN) RETURNS BOOLEAN;
CREATE FUNCTION booleq(BOOLEAN, BOOLEAN) RETURNS BOOLEAN;
CREATE FUNCTION boolge(BOOLEAN, BOOLEAN) RETURNS BOOLEAN;
CREATE FUNCTION boolgt(BOOLEAN, BOOLEAN) RETURNS BOOLEAN;
CREATE FUNCTION boolin(CSTRING) RETURNS BOOLEAN;
CREATE FUNCTION boolle(BOOLEAN, BOOLEAN) RETURNS BOOLEAN;
CREATE FUNCTION boollt(BOOLEAN, BOOLEAN) RETURNS BOOLEAN;
CREATE FUNCTION boolne(BOOLEAN, BOOLEAN) RETURNS BOOLEAN;
CREATE FUNCTION boolor_statefunc(BOOLEAN, BOOLEAN) RETURNS BOOLEAN;
CREATE FUNCTION boolout(BOOLEAN) RETURNS CSTRING;
CREATE FUNCTION boolrecv(INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION boolsend(BOOLEAN) RETURNS BYTEA;
CREATE FUNCTION bound_box(BOX, BOX) RETURNS BOX;
CREATE FUNCTION box(CIRCLE) RETURNS BOX;
CREATE FUNCTION box(POINT) RETURNS BOX;
CREATE FUNCTION box(POINT, POINT) RETURNS BOX;
CREATE FUNCTION box(POLYGON) RETURNS BOX;
CREATE FUNCTION box_above(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_above_eq(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_add(BOX, POINT) RETURNS BOX;
CREATE FUNCTION box_below(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_below_eq(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_center(BOX) RETURNS POINT;
CREATE FUNCTION box_contain(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_contain_pt(BOX, POINT) RETURNS BOOLEAN;
CREATE FUNCTION box_contained(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_distance(BOX, BOX) RETURNS DOUBLE PRECISION;
CREATE FUNCTION box_div(BOX, POINT) RETURNS BOX;
CREATE FUNCTION box_eq(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_ge(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_gt(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_in(CSTRING) RETURNS BOX;
CREATE FUNCTION box_intersect(BOX, BOX) RETURNS BOX;
CREATE FUNCTION box_le(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_left(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_lt(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_mul(BOX, POINT) RETURNS BOX;
CREATE FUNCTION box_out(BOX) RETURNS CSTRING;
CREATE FUNCTION box_overabove(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_overbelow(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_overlap(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_overleft(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_overright(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_recv(INTERNAL) RETURNS BOX;
CREATE FUNCTION box_right(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_same(BOX, BOX) RETURNS BOOLEAN;
CREATE FUNCTION box_send(BOX) RETURNS BYTEA;
CREATE FUNCTION box_sub(BOX, POINT) RETURNS BOX;
CREATE FUNCTION bpchar("char") RETURNS CHAR;
CREATE FUNCTION bpchar(CHAR, INTEGER, BOOLEAN) RETURNS CHAR;
CREATE FUNCTION bpchar(NAME) RETURNS CHAR;
CREATE FUNCTION bpchar_larger(CHAR, CHAR) RETURNS CHAR;
CREATE FUNCTION bpchar_pattern_ge(CHAR, CHAR) RETURNS BOOLEAN;
CREATE FUNCTION bpchar_pattern_gt(CHAR, CHAR) RETURNS BOOLEAN;
CREATE FUNCTION bpchar_pattern_le(CHAR, CHAR) RETURNS BOOLEAN;
CREATE FUNCTION bpchar_pattern_lt(CHAR, CHAR) RETURNS BOOLEAN;
CREATE FUNCTION bpchar_smaller(CHAR, CHAR) RETURNS CHAR;
CREATE FUNCTION bpcharcmp(CHAR, CHAR) RETURNS INTEGER;
CREATE FUNCTION bpchareq(CHAR, CHAR) RETURNS BOOLEAN;
CREATE FUNCTION bpcharge(CHAR, CHAR) RETURNS BOOLEAN;
CREATE FUNCTION bpchargt(CHAR, CHAR) RETURNS BOOLEAN;
CREATE FUNCTION bpchariclike(CHAR, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION bpcharicnlike(CHAR, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION bpcharicregexeq(CHAR, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION bpcharicregexne(CHAR, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION bpcharin(CSTRING, OID, INTEGER) RETURNS CHAR;
CREATE FUNCTION bpcharle(CHAR, CHAR) RETURNS BOOLEAN;
CREATE FUNCTION bpcharlike(CHAR, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION bpcharlt(CHAR, CHAR) RETURNS BOOLEAN;
CREATE FUNCTION bpcharne(CHAR, CHAR) RETURNS BOOLEAN;
CREATE FUNCTION bpcharnlike(CHAR, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION bpcharout(CHAR) RETURNS CSTRING;
CREATE FUNCTION bpcharrecv(INTERNAL, OID, INTEGER) RETURNS CHAR;
CREATE FUNCTION bpcharregexeq(CHAR, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION bpcharregexne(CHAR, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION bpcharsend(CHAR) RETURNS BYTEA;
CREATE FUNCTION bpchartypmodin(CSTRING[]) RETURNS INTEGER;
CREATE FUNCTION bpchartypmodout(INTEGER) RETURNS CSTRING;
CREATE FUNCTION brin_inclusion_add_value(INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION brin_inclusion_consistent(INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION brin_inclusion_opcinfo(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION brin_inclusion_union(INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION brin_minmax_add_value(INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION brin_minmax_consistent(INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION brin_minmax_opcinfo(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION brin_minmax_union(INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION brin_summarize_new_values(REGCLASS) RETURNS INTEGER;
CREATE FUNCTION brinbeginscan(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION brinbuild(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION brinbuildempty(INTERNAL) RETURNS VOID;
CREATE FUNCTION brinbulkdelete(INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION brincostestimate(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION brinendscan(INTERNAL) RETURNS VOID;
CREATE FUNCTION bringetbitmap(INTERNAL, INTERNAL) RETURNS BIGINT;
CREATE FUNCTION brininsert(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION brinmarkpos(INTERNAL) RETURNS VOID;
CREATE FUNCTION brinoptions(TEXT[], BOOLEAN) RETURNS BYTEA;
CREATE FUNCTION brinrescan(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION brinrestrpos(INTERNAL) RETURNS VOID;
CREATE FUNCTION brinvacuumcleanup(INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION broadcast(INET) RETURNS INET;
CREATE FUNCTION btabstimecmp(ABSTIME, ABSTIME) RETURNS INTEGER;
CREATE FUNCTION btarraycmp(ANYARRAY, ANYARRAY) RETURNS INTEGER;
CREATE FUNCTION btbeginscan(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION btboolcmp(BOOLEAN, BOOLEAN) RETURNS INTEGER;
CREATE FUNCTION btbpchar_pattern_cmp(CHAR, CHAR) RETURNS INTEGER;
CREATE FUNCTION btbuild(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION btbuildempty(INTERNAL) RETURNS VOID;
CREATE FUNCTION btbulkdelete(INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION btcanreturn(INTERNAL, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION btcharcmp("char", "char") RETURNS INTEGER;
CREATE FUNCTION btcostestimate(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION btendscan(INTERNAL) RETURNS VOID;
CREATE FUNCTION btfloat48cmp(REAL, DOUBLE PRECISION) RETURNS INTEGER;
CREATE FUNCTION btfloat4cmp(REAL, REAL) RETURNS INTEGER;
CREATE FUNCTION btfloat4sortsupport(INTERNAL) RETURNS VOID;
CREATE FUNCTION btfloat84cmp(DOUBLE PRECISION, REAL) RETURNS INTEGER;
CREATE FUNCTION btfloat8cmp(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS INTEGER;
CREATE FUNCTION btfloat8sortsupport(INTERNAL) RETURNS VOID;
CREATE FUNCTION btgetbitmap(INTERNAL, INTERNAL) RETURNS BIGINT;
CREATE FUNCTION btgettuple(INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION btinsert(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION btint24cmp(SMALLINT, INTEGER) RETURNS INTEGER;
CREATE FUNCTION btint28cmp(SMALLINT, BIGINT) RETURNS INTEGER;
CREATE FUNCTION btint2cmp(SMALLINT, SMALLINT) RETURNS INTEGER;
CREATE FUNCTION btint2sortsupport(INTERNAL) RETURNS VOID;
CREATE FUNCTION btint42cmp(INTEGER, SMALLINT) RETURNS INTEGER;
CREATE FUNCTION btint48cmp(INTEGER, BIGINT) RETURNS INTEGER;
CREATE FUNCTION btint4cmp(INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION btint4sortsupport(INTERNAL) RETURNS VOID;
CREATE FUNCTION btint82cmp(BIGINT, SMALLINT) RETURNS INTEGER;
CREATE FUNCTION btint84cmp(BIGINT, INTEGER) RETURNS INTEGER;
CREATE FUNCTION btint8cmp(BIGINT, BIGINT) RETURNS INTEGER;
CREATE FUNCTION btint8sortsupport(INTERNAL) RETURNS VOID;
CREATE FUNCTION btmarkpos(INTERNAL) RETURNS VOID;
CREATE FUNCTION btnamecmp(NAME, NAME) RETURNS INTEGER;
CREATE FUNCTION btnamesortsupport(INTERNAL) RETURNS VOID;
CREATE FUNCTION btoidcmp(OID, OID) RETURNS INTEGER;
CREATE FUNCTION btoidsortsupport(INTERNAL) RETURNS VOID;
CREATE FUNCTION btoidvectorcmp(OIDVECTOR, OIDVECTOR) RETURNS INTEGER;
CREATE FUNCTION btoptions(TEXT[], BOOLEAN) RETURNS BYTEA;
CREATE FUNCTION btrecordcmp(RECORD, RECORD) RETURNS INTEGER;
CREATE FUNCTION btrecordimagecmp(RECORD, RECORD) RETURNS INTEGER;
CREATE FUNCTION btreltimecmp(RELTIME, RELTIME) RETURNS INTEGER;
CREATE FUNCTION btrescan(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION btrestrpos(INTERNAL) RETURNS VOID;
CREATE FUNCTION btrim(BYTEA, BYTEA) RETURNS BYTEA;
CREATE FUNCTION btrim(TEXT) RETURNS TEXT;
CREATE FUNCTION btrim(TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION bttext_pattern_cmp(TEXT, TEXT) RETURNS INTEGER;
CREATE FUNCTION bttextcmp(TEXT, TEXT) RETURNS INTEGER;
CREATE FUNCTION bttextsortsupport(INTERNAL) RETURNS VOID;
CREATE FUNCTION bttidcmp(TID, TID) RETURNS INTEGER;
CREATE FUNCTION bttintervalcmp(TINTERVAL, TINTERVAL) RETURNS INTEGER;
CREATE FUNCTION btvacuumcleanup(INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION bytea_string_agg_finalfn(INTERNAL) RETURNS BYTEA;
CREATE FUNCTION bytea_string_agg_transfn(INTERNAL, BYTEA, BYTEA) RETURNS INTERNAL;
CREATE FUNCTION byteacat(BYTEA, BYTEA) RETURNS BYTEA;
CREATE FUNCTION byteacmp(BYTEA, BYTEA) RETURNS INTEGER;
CREATE FUNCTION byteaeq(BYTEA, BYTEA) RETURNS BOOLEAN;
CREATE FUNCTION byteage(BYTEA, BYTEA) RETURNS BOOLEAN;
CREATE FUNCTION byteagt(BYTEA, BYTEA) RETURNS BOOLEAN;
CREATE FUNCTION byteain(CSTRING) RETURNS BYTEA;
CREATE FUNCTION byteale(BYTEA, BYTEA) RETURNS BOOLEAN;
CREATE FUNCTION bytealike(BYTEA, BYTEA) RETURNS BOOLEAN;
CREATE FUNCTION bytealt(BYTEA, BYTEA) RETURNS BOOLEAN;
CREATE FUNCTION byteane(BYTEA, BYTEA) RETURNS BOOLEAN;
CREATE FUNCTION byteanlike(BYTEA, BYTEA) RETURNS BOOLEAN;
CREATE FUNCTION byteaout(BYTEA) RETURNS CSTRING;
CREATE FUNCTION bytearecv(INTERNAL) RETURNS BYTEA;
CREATE FUNCTION byteasend(BYTEA) RETURNS BYTEA;
CREATE FUNCTION cardinality(ANYARRAY) RETURNS INTEGER;
CREATE FUNCTION cash_cmp(MONEY, MONEY) RETURNS INTEGER;
CREATE FUNCTION cash_div_cash(MONEY, MONEY) RETURNS DOUBLE PRECISION;
CREATE FUNCTION cash_div_flt4(MONEY, REAL) RETURNS MONEY;
CREATE FUNCTION cash_div_flt8(MONEY, DOUBLE PRECISION) RETURNS MONEY;
CREATE FUNCTION cash_div_int2(MONEY, SMALLINT) RETURNS MONEY;
CREATE FUNCTION cash_div_int4(MONEY, INTEGER) RETURNS MONEY;
CREATE FUNCTION cash_eq(MONEY, MONEY) RETURNS BOOLEAN;
CREATE FUNCTION cash_ge(MONEY, MONEY) RETURNS BOOLEAN;
CREATE FUNCTION cash_gt(MONEY, MONEY) RETURNS BOOLEAN;
CREATE FUNCTION cash_in(CSTRING) RETURNS MONEY;
CREATE FUNCTION cash_le(MONEY, MONEY) RETURNS BOOLEAN;
CREATE FUNCTION cash_lt(MONEY, MONEY) RETURNS BOOLEAN;
CREATE FUNCTION cash_mi(MONEY, MONEY) RETURNS MONEY;
CREATE FUNCTION cash_mul_flt4(MONEY, REAL) RETURNS MONEY;
CREATE FUNCTION cash_mul_flt8(MONEY, DOUBLE PRECISION) RETURNS MONEY;
CREATE FUNCTION cash_mul_int2(MONEY, SMALLINT) RETURNS MONEY;
CREATE FUNCTION cash_mul_int4(MONEY, INTEGER) RETURNS MONEY;
CREATE FUNCTION cash_ne(MONEY, MONEY) RETURNS BOOLEAN;
CREATE FUNCTION cash_out(MONEY) RETURNS CSTRING;
CREATE FUNCTION cash_pl(MONEY, MONEY) RETURNS MONEY;
CREATE FUNCTION cash_recv(INTERNAL) RETURNS MONEY;
CREATE FUNCTION cash_send(MONEY) RETURNS BYTEA;
CREATE FUNCTION cash_words(MONEY) RETURNS TEXT;
CREATE FUNCTION cashlarger(MONEY, MONEY) RETURNS MONEY;
CREATE FUNCTION cashsmaller(MONEY, MONEY) RETURNS MONEY;
CREATE FUNCTION cbrt(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION ceil(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION ceil(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION ceiling(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION ceiling(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION center(BOX) RETURNS POINT;
CREATE FUNCTION center(CIRCLE) RETURNS POINT;
CREATE FUNCTION char(INTEGER) RETURNS "char";
CREATE FUNCTION char(TEXT) RETURNS "char";
CREATE FUNCTION char_length(CHAR) RETURNS INTEGER;
CREATE FUNCTION char_length(TEXT) RETURNS INTEGER;
CREATE FUNCTION character_length(CHAR) RETURNS INTEGER;
CREATE FUNCTION character_length(TEXT) RETURNS INTEGER;
CREATE FUNCTION chareq("char", "char") RETURNS BOOLEAN;
CREATE FUNCTION charge("char", "char") RETURNS BOOLEAN;
CREATE FUNCTION chargt("char", "char") RETURNS BOOLEAN;
CREATE FUNCTION charin(CSTRING) RETURNS "char";
CREATE FUNCTION charle("char", "char") RETURNS BOOLEAN;
CREATE FUNCTION charlt("char", "char") RETURNS BOOLEAN;
CREATE FUNCTION charne("char", "char") RETURNS BOOLEAN;
CREATE FUNCTION charout("char") RETURNS CSTRING;
CREATE FUNCTION charrecv(INTERNAL) RETURNS "char";
CREATE FUNCTION charsend("char") RETURNS BYTEA;
CREATE FUNCTION chr(INTEGER) RETURNS TEXT;
CREATE FUNCTION cideq(CID, CID) RETURNS BOOLEAN;
CREATE FUNCTION cidin(CSTRING) RETURNS CID;
CREATE FUNCTION cidout(CID) RETURNS CSTRING;
CREATE FUNCTION cidr(INET) RETURNS CIDR;
CREATE FUNCTION cidr_in(CSTRING) RETURNS CIDR;
CREATE FUNCTION cidr_out(CIDR) RETURNS CSTRING;
CREATE FUNCTION cidr_recv(INTERNAL) RETURNS CIDR;
CREATE FUNCTION cidr_send(CIDR) RETURNS BYTEA;
CREATE FUNCTION cidrecv(INTERNAL) RETURNS CID;
CREATE FUNCTION cidsend(CID) RETURNS BYTEA;
CREATE FUNCTION circle(BOX) RETURNS CIRCLE;
CREATE FUNCTION circle(POINT, DOUBLE PRECISION) RETURNS CIRCLE;
CREATE FUNCTION circle(POLYGON) RETURNS CIRCLE;
CREATE FUNCTION circle_above(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_add_pt(CIRCLE, POINT) RETURNS CIRCLE;
CREATE FUNCTION circle_below(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_center(CIRCLE) RETURNS POINT;
CREATE FUNCTION circle_contain(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_contain_pt(CIRCLE, POINT) RETURNS BOOLEAN;
CREATE FUNCTION circle_contained(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_distance(CIRCLE, CIRCLE) RETURNS DOUBLE PRECISION;
CREATE FUNCTION circle_div_pt(CIRCLE, POINT) RETURNS CIRCLE;
CREATE FUNCTION circle_eq(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_ge(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_gt(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_in(CSTRING) RETURNS CIRCLE;
CREATE FUNCTION circle_le(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_left(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_lt(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_mul_pt(CIRCLE, POINT) RETURNS CIRCLE;
CREATE FUNCTION circle_ne(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_out(CIRCLE) RETURNS CSTRING;
CREATE FUNCTION circle_overabove(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_overbelow(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_overlap(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_overleft(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_overright(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_recv(INTERNAL) RETURNS CIRCLE;
CREATE FUNCTION circle_right(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_same(CIRCLE, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION circle_send(CIRCLE) RETURNS BYTEA;
CREATE FUNCTION circle_sub_pt(CIRCLE, POINT) RETURNS CIRCLE;
CREATE FUNCTION clock_timestamp() RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION close_lb(LINE, BOX) RETURNS POINT;
CREATE FUNCTION close_ls(LINE, LSEG) RETURNS POINT;
CREATE FUNCTION close_lseg(LSEG, LSEG) RETURNS POINT;
CREATE FUNCTION close_pb(POINT, BOX) RETURNS POINT;
CREATE FUNCTION close_pl(POINT, LINE) RETURNS POINT;
CREATE FUNCTION close_ps(POINT, LSEG) RETURNS POINT;
CREATE FUNCTION close_sb(LSEG, BOX) RETURNS POINT;
CREATE FUNCTION close_sl(LSEG, LINE) RETURNS POINT;
CREATE FUNCTION col_description(OID, INTEGER) RETURNS TEXT;
CREATE FUNCTION concat("any") RETURNS TEXT;
CREATE FUNCTION concat_ws(TEXT, "any") RETURNS TEXT;
CREATE FUNCTION contjoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION contsel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION convert(BYTEA, NAME, NAME) RETURNS BYTEA;
CREATE FUNCTION convert_from(BYTEA, NAME) RETURNS TEXT;
CREATE FUNCTION convert_to(TEXT, NAME) RETURNS BYTEA;
CREATE FUNCTION corr(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION cos(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION cot(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION count("any") RETURNS BIGINT;
CREATE FUNCTION count() RETURNS BIGINT;
CREATE FUNCTION covar_pop(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION covar_samp(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION cstring_in(CSTRING) RETURNS CSTRING;
CREATE FUNCTION cstring_out(CSTRING) RETURNS CSTRING;
CREATE FUNCTION cstring_recv(INTERNAL) RETURNS CSTRING;
CREATE FUNCTION cstring_send(CSTRING) RETURNS BYTEA;
CREATE FUNCTION cume_dist("any") RETURNS DOUBLE PRECISION;
CREATE FUNCTION cume_dist() RETURNS DOUBLE PRECISION;
CREATE FUNCTION cume_dist_final(INTERNAL, "any") RETURNS DOUBLE PRECISION;
CREATE FUNCTION current_database() RETURNS NAME;
CREATE FUNCTION current_query() RETURNS TEXT;
CREATE FUNCTION "current_schema"() RETURNS NAME;
CREATE FUNCTION current_schemas(BOOLEAN) RETURNS NAME[];
CREATE FUNCTION current_setting(TEXT) RETURNS TEXT;
CREATE FUNCTION "current_user"() RETURNS NAME;
CREATE FUNCTION currtid(OID, TID) RETURNS TID;
CREATE FUNCTION currtid2(TEXT, TID) RETURNS TID;
CREATE FUNCTION currval(REGCLASS) RETURNS BIGINT;
CREATE FUNCTION cursor_to_xml(cursor REFCURSOR, count INTEGER, nulls BOOLEAN, tableforest BOOLEAN, targetns TEXT) RETURNS XML;
CREATE FUNCTION cursor_to_xmlschema(cursor REFCURSOR, nulls BOOLEAN, tableforest BOOLEAN, targetns TEXT) RETURNS XML;
CREATE FUNCTION database_to_xml(nulls BOOLEAN, tableforest BOOLEAN, targetns TEXT) RETURNS XML;
CREATE FUNCTION database_to_xml_and_xmlschema(nulls BOOLEAN, tableforest BOOLEAN, targetns TEXT) RETURNS XML;
CREATE FUNCTION database_to_xmlschema(nulls BOOLEAN, tableforest BOOLEAN, targetns TEXT) RETURNS XML;
CREATE FUNCTION date(ABSTIME) RETURNS DATE;
CREATE FUNCTION date(TIMESTAMP WITH TIME ZONE) RETURNS DATE;
CREATE FUNCTION date(TIMESTAMP) RETURNS DATE;
CREATE FUNCTION date_cmp(DATE, DATE) RETURNS INTEGER;
CREATE FUNCTION date_cmp_timestamp(DATE, TIMESTAMP) RETURNS INTEGER;
CREATE FUNCTION date_cmp_timestamptz(DATE, TIMESTAMP WITH TIME ZONE) RETURNS INTEGER;
CREATE FUNCTION date_eq(DATE, DATE) RETURNS BOOLEAN;
CREATE FUNCTION date_eq_timestamp(DATE, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION date_eq_timestamptz(DATE, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION date_ge(DATE, DATE) RETURNS BOOLEAN;
CREATE FUNCTION date_ge_timestamp(DATE, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION date_ge_timestamptz(DATE, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION date_gt(DATE, DATE) RETURNS BOOLEAN;
CREATE FUNCTION date_gt_timestamp(DATE, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION date_gt_timestamptz(DATE, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION date_in(CSTRING) RETURNS DATE;
CREATE FUNCTION date_larger(DATE, DATE) RETURNS DATE;
CREATE FUNCTION date_le(DATE, DATE) RETURNS BOOLEAN;
CREATE FUNCTION date_le_timestamp(DATE, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION date_le_timestamptz(DATE, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION date_lt(DATE, DATE) RETURNS BOOLEAN;
CREATE FUNCTION date_lt_timestamp(DATE, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION date_lt_timestamptz(DATE, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION date_mi(DATE, DATE) RETURNS INTEGER;
CREATE FUNCTION date_mi_interval(DATE, INTERVAL) RETURNS TIMESTAMP;
CREATE FUNCTION date_mii(DATE, INTEGER) RETURNS DATE;
CREATE FUNCTION date_ne(DATE, DATE) RETURNS BOOLEAN;
CREATE FUNCTION date_ne_timestamp(DATE, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION date_ne_timestamptz(DATE, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION date_out(DATE) RETURNS CSTRING;
CREATE FUNCTION date_part(TEXT, ABSTIME) RETURNS DOUBLE PRECISION;
CREATE FUNCTION date_part(TEXT, DATE) RETURNS DOUBLE PRECISION;
CREATE FUNCTION date_part(TEXT, INTERVAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION date_part(TEXT, RELTIME) RETURNS DOUBLE PRECISION;
CREATE FUNCTION date_part(TEXT, TIME WITH TIME ZONE) RETURNS DOUBLE PRECISION;
CREATE FUNCTION date_part(TEXT, TIME) RETURNS DOUBLE PRECISION;
CREATE FUNCTION date_part(TEXT, TIMESTAMP WITH TIME ZONE) RETURNS DOUBLE PRECISION;
CREATE FUNCTION date_part(TEXT, TIMESTAMP) RETURNS DOUBLE PRECISION;
CREATE FUNCTION date_pl_interval(DATE, INTERVAL) RETURNS TIMESTAMP;
CREATE FUNCTION date_pli(DATE, INTEGER) RETURNS DATE;
CREATE FUNCTION date_recv(INTERNAL) RETURNS DATE;
CREATE FUNCTION date_send(DATE) RETURNS BYTEA;
CREATE FUNCTION date_smaller(DATE, DATE) RETURNS DATE;
CREATE FUNCTION date_sortsupport(INTERNAL) RETURNS VOID;
CREATE FUNCTION date_trunc(TEXT, INTERVAL) RETURNS INTERVAL;
CREATE FUNCTION date_trunc(TEXT, TIMESTAMP WITH TIME ZONE) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION date_trunc(TEXT, TIMESTAMP) RETURNS TIMESTAMP;
CREATE FUNCTION daterange(DATE, DATE) RETURNS DATERANGE;
CREATE FUNCTION daterange(DATE, DATE, TEXT) RETURNS DATERANGE;
CREATE FUNCTION daterange_canonical(DATERANGE) RETURNS DATERANGE;
CREATE FUNCTION daterange_subdiff(DATE, DATE) RETURNS DOUBLE PRECISION;
CREATE FUNCTION datetime_pl(DATE, TIME) RETURNS TIMESTAMP;
CREATE FUNCTION datetimetz_pl(DATE, TIME WITH TIME ZONE) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION dcbrt(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION decode(TEXT, TEXT) RETURNS BYTEA;
CREATE FUNCTION degrees(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dense_rank("any") RETURNS BIGINT;
CREATE FUNCTION dense_rank() RETURNS BIGINT;
CREATE FUNCTION dense_rank_final(INTERNAL, "any") RETURNS BIGINT;
CREATE FUNCTION dexp(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION diagonal(BOX) RETURNS LSEG;
CREATE FUNCTION diameter(CIRCLE) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dispell_init(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION dispell_lexize(INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION dist_cpoint(CIRCLE, POINT) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dist_cpoly(CIRCLE, POLYGON) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dist_lb(LINE, BOX) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dist_pb(POINT, BOX) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dist_pc(POINT, CIRCLE) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dist_pl(POINT, LINE) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dist_polyp(POLYGON, POINT) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dist_ppath(POINT, PATH) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dist_ppoly(POINT, POLYGON) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dist_ps(POINT, LSEG) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dist_sb(LSEG, BOX) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dist_sl(LSEG, LINE) RETURNS DOUBLE PRECISION;
CREATE FUNCTION div(NUMERIC, NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION dlog1(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dlog10(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION domain_in(CSTRING, OID, INTEGER) RETURNS "any";
CREATE FUNCTION domain_recv(INTERNAL, OID, INTEGER) RETURNS "any";
CREATE FUNCTION dpow(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dround(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dsimple_init(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION dsimple_lexize(INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION dsnowball_init(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION dsnowball_lexize(INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION dsqrt(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION dsynonym_init(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION dsynonym_lexize(INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION dtrunc(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION elem_contained_by_range(ANYELEMENT, ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION encode(BYTEA, TEXT) RETURNS TEXT;
CREATE FUNCTION enum_cmp(ANYENUM, ANYENUM) RETURNS INTEGER;
CREATE FUNCTION enum_eq(ANYENUM, ANYENUM) RETURNS BOOLEAN;
CREATE FUNCTION enum_first(ANYENUM) RETURNS ANYENUM;
CREATE FUNCTION enum_ge(ANYENUM, ANYENUM) RETURNS BOOLEAN;
CREATE FUNCTION enum_gt(ANYENUM, ANYENUM) RETURNS BOOLEAN;
CREATE FUNCTION enum_in(CSTRING, OID) RETURNS ANYENUM;
CREATE FUNCTION enum_larger(ANYENUM, ANYENUM) RETURNS ANYENUM;
CREATE FUNCTION enum_last(ANYENUM) RETURNS ANYENUM;
CREATE FUNCTION enum_le(ANYENUM, ANYENUM) RETURNS BOOLEAN;
CREATE FUNCTION enum_lt(ANYENUM, ANYENUM) RETURNS BOOLEAN;
CREATE FUNCTION enum_ne(ANYENUM, ANYENUM) RETURNS BOOLEAN;
CREATE FUNCTION enum_out(ANYENUM) RETURNS CSTRING;
CREATE FUNCTION enum_range(ANYENUM) RETURNS ANYARRAY;
CREATE FUNCTION enum_range(ANYENUM, ANYENUM) RETURNS ANYARRAY;
CREATE FUNCTION enum_recv(INTERNAL, OID) RETURNS ANYENUM;
CREATE FUNCTION enum_send(ANYENUM) RETURNS BYTEA;
CREATE FUNCTION enum_smaller(ANYENUM, ANYENUM) RETURNS ANYENUM;
CREATE FUNCTION eqjoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION eqsel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION euc_cn_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION euc_cn_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION euc_jis_2004_to_shift_jis_2004(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION euc_jis_2004_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION euc_jp_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION euc_jp_to_sjis(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION euc_jp_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION euc_kr_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION euc_kr_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION euc_tw_to_big5(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION euc_tw_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION euc_tw_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION event_trigger_in(CSTRING) RETURNS EVENT_TRIGGER;
CREATE FUNCTION event_trigger_out(EVENT_TRIGGER) RETURNS CSTRING;
CREATE FUNCTION every(BOOLEAN) RETURNS BOOLEAN;
CREATE FUNCTION exp(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION exp(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION factorial(BIGINT) RETURNS NUMERIC;
CREATE FUNCTION family(INET) RETURNS INTEGER;
CREATE FUNCTION fdw_handler_in(CSTRING) RETURNS FDW_HANDLER;
CREATE FUNCTION fdw_handler_out(FDW_HANDLER) RETURNS CSTRING;
CREATE FUNCTION first_value(ANYELEMENT) RETURNS ANYELEMENT;
CREATE FUNCTION float4(BIGINT) RETURNS REAL;
CREATE FUNCTION float4(DOUBLE PRECISION) RETURNS REAL;
CREATE FUNCTION float4(INTEGER) RETURNS REAL;
CREATE FUNCTION float4(NUMERIC) RETURNS REAL;
CREATE FUNCTION float4(SMALLINT) RETURNS REAL;
CREATE FUNCTION float48div(REAL, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float48eq(REAL, DOUBLE PRECISION) RETURNS BOOLEAN;
CREATE FUNCTION float48ge(REAL, DOUBLE PRECISION) RETURNS BOOLEAN;
CREATE FUNCTION float48gt(REAL, DOUBLE PRECISION) RETURNS BOOLEAN;
CREATE FUNCTION float48le(REAL, DOUBLE PRECISION) RETURNS BOOLEAN;
CREATE FUNCTION float48lt(REAL, DOUBLE PRECISION) RETURNS BOOLEAN;
CREATE FUNCTION float48mi(REAL, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float48mul(REAL, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float48ne(REAL, DOUBLE PRECISION) RETURNS BOOLEAN;
CREATE FUNCTION float48pl(REAL, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float4_accum(DOUBLE PRECISION[], REAL) RETURNS DOUBLE PRECISION[];
CREATE FUNCTION float4abs(REAL) RETURNS REAL;
CREATE FUNCTION float4div(REAL, REAL) RETURNS REAL;
CREATE FUNCTION float4eq(REAL, REAL) RETURNS BOOLEAN;
CREATE FUNCTION float4ge(REAL, REAL) RETURNS BOOLEAN;
CREATE FUNCTION float4gt(REAL, REAL) RETURNS BOOLEAN;
CREATE FUNCTION float4in(CSTRING) RETURNS REAL;
CREATE FUNCTION float4larger(REAL, REAL) RETURNS REAL;
CREATE FUNCTION float4le(REAL, REAL) RETURNS BOOLEAN;
CREATE FUNCTION float4lt(REAL, REAL) RETURNS BOOLEAN;
CREATE FUNCTION float4mi(REAL, REAL) RETURNS REAL;
CREATE FUNCTION float4mul(REAL, REAL) RETURNS REAL;
CREATE FUNCTION float4ne(REAL, REAL) RETURNS BOOLEAN;
CREATE FUNCTION float4out(REAL) RETURNS CSTRING;
CREATE FUNCTION float4pl(REAL, REAL) RETURNS REAL;
CREATE FUNCTION float4recv(INTERNAL) RETURNS REAL;
CREATE FUNCTION float4send(REAL) RETURNS BYTEA;
CREATE FUNCTION float4smaller(REAL, REAL) RETURNS REAL;
CREATE FUNCTION float4um(REAL) RETURNS REAL;
CREATE FUNCTION float4up(REAL) RETURNS REAL;
CREATE FUNCTION float8(BIGINT) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8(INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8(NUMERIC) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8(REAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8(SMALLINT) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float84div(DOUBLE PRECISION, REAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float84eq(DOUBLE PRECISION, REAL) RETURNS BOOLEAN;
CREATE FUNCTION float84ge(DOUBLE PRECISION, REAL) RETURNS BOOLEAN;
CREATE FUNCTION float84gt(DOUBLE PRECISION, REAL) RETURNS BOOLEAN;
CREATE FUNCTION float84le(DOUBLE PRECISION, REAL) RETURNS BOOLEAN;
CREATE FUNCTION float84lt(DOUBLE PRECISION, REAL) RETURNS BOOLEAN;
CREATE FUNCTION float84mi(DOUBLE PRECISION, REAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float84mul(DOUBLE PRECISION, REAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float84ne(DOUBLE PRECISION, REAL) RETURNS BOOLEAN;
CREATE FUNCTION float84pl(DOUBLE PRECISION, REAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_accum(DOUBLE PRECISION[], DOUBLE PRECISION) RETURNS DOUBLE PRECISION[];
CREATE FUNCTION float8_avg(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_corr(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_covar_pop(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_covar_samp(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_regr_accum(DOUBLE PRECISION[], DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION[];
CREATE FUNCTION float8_regr_avgx(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_regr_avgy(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_regr_intercept(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_regr_r2(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_regr_slope(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_regr_sxx(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_regr_sxy(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_regr_syy(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_stddev_pop(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_stddev_samp(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_var_pop(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8_var_samp(DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8abs(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8div(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8eq(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS BOOLEAN;
CREATE FUNCTION float8ge(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS BOOLEAN;
CREATE FUNCTION float8gt(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS BOOLEAN;
CREATE FUNCTION float8in(CSTRING) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8larger(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8le(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS BOOLEAN;
CREATE FUNCTION float8lt(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS BOOLEAN;
CREATE FUNCTION float8mi(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8mul(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8ne(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS BOOLEAN;
CREATE FUNCTION float8out(DOUBLE PRECISION) RETURNS CSTRING;
CREATE FUNCTION float8pl(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8recv(INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8send(DOUBLE PRECISION) RETURNS BYTEA;
CREATE FUNCTION float8smaller(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8um(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION float8up(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION floor(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION floor(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION flt4_mul_cash(REAL, MONEY) RETURNS MONEY;
CREATE FUNCTION flt8_mul_cash(DOUBLE PRECISION, MONEY) RETURNS MONEY;
CREATE FUNCTION fmgr_c_validator(OID) RETURNS VOID;
CREATE FUNCTION fmgr_internal_validator(OID) RETURNS VOID;
CREATE FUNCTION fmgr_sql_validator(OID) RETURNS VOID;
CREATE FUNCTION format(TEXT) RETURNS TEXT;
CREATE FUNCTION format(TEXT, "any") RETURNS TEXT;
CREATE FUNCTION format_type(OID, INTEGER) RETURNS TEXT;
CREATE FUNCTION gb18030_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION gbk_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION generate_series(BIGINT, BIGINT) RETURNS SETOF BIGINT;
CREATE FUNCTION generate_series(BIGINT, BIGINT, BIGINT) RETURNS SETOF BIGINT;
CREATE FUNCTION generate_series(INTEGER, INTEGER) RETURNS SETOF INTEGER;
CREATE FUNCTION generate_series(INTEGER, INTEGER, INTEGER) RETURNS SETOF INTEGER;
CREATE FUNCTION generate_series(NUMERIC, NUMERIC) RETURNS SETOF NUMERIC;
CREATE FUNCTION generate_series(NUMERIC, NUMERIC, NUMERIC) RETURNS SETOF NUMERIC;
CREATE FUNCTION generate_series(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE, INTERVAL) RETURNS SETOF TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION generate_series(TIMESTAMP, TIMESTAMP, INTERVAL) RETURNS SETOF TIMESTAMP;
CREATE FUNCTION generate_subscripts(ANYARRAY, INTEGER) RETURNS SETOF INTEGER;
CREATE FUNCTION generate_subscripts(ANYARRAY, INTEGER, BOOLEAN) RETURNS SETOF INTEGER;
CREATE FUNCTION get_bit(BIT, INTEGER) RETURNS INTEGER;
CREATE FUNCTION get_bit(BYTEA, INTEGER) RETURNS INTEGER;
CREATE FUNCTION get_byte(BYTEA, INTEGER) RETURNS INTEGER;
CREATE FUNCTION get_current_ts_config() RETURNS REGCONFIG;
CREATE FUNCTION getdatabaseencoding() RETURNS NAME;
CREATE FUNCTION getpgusername() RETURNS NAME;
CREATE FUNCTION gin_cmp_prefix(TEXT, TEXT, SMALLINT, INTERNAL) RETURNS INTEGER;
CREATE FUNCTION gin_cmp_tslexeme(TEXT, TEXT) RETURNS INTEGER;
CREATE FUNCTION gin_compare_jsonb(TEXT, TEXT) RETURNS INTEGER;
CREATE FUNCTION gin_consistent_jsonb(INTERNAL, SMALLINT, ANYARRAY, INTEGER, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION gin_consistent_jsonb_path(INTERNAL, SMALLINT, ANYARRAY, INTEGER, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION gin_extract_jsonb(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gin_extract_jsonb_path(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gin_extract_jsonb_query(ANYARRAY, INTERNAL, SMALLINT, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gin_extract_jsonb_query_path(ANYARRAY, INTERNAL, SMALLINT, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gin_extract_tsquery(TSQUERY, INTERNAL, SMALLINT, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gin_extract_tsquery(TSQUERY, INTERNAL, SMALLINT, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gin_extract_tsvector(TSVECTOR, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gin_extract_tsvector(TSVECTOR, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gin_triconsistent_jsonb(INTERNAL, SMALLINT, ANYARRAY, INTEGER, INTERNAL, INTERNAL, INTERNAL) RETURNS "char";
CREATE FUNCTION gin_triconsistent_jsonb_path(INTERNAL, SMALLINT, ANYARRAY, INTEGER, INTERNAL, INTERNAL, INTERNAL) RETURNS "char";
CREATE FUNCTION gin_tsquery_consistent(INTERNAL, SMALLINT, TSQUERY, INTEGER, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION gin_tsquery_consistent(INTERNAL, SMALLINT, TSQUERY, INTEGER, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION gin_tsquery_triconsistent(INTERNAL, SMALLINT, TSQUERY, INTEGER, INTERNAL, INTERNAL, INTERNAL) RETURNS "char";
CREATE FUNCTION ginarrayconsistent(INTERNAL, SMALLINT, ANYARRAY, INTEGER, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION ginarrayextract(ANYARRAY, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION ginarrayextract(ANYARRAY, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION ginarraytriconsistent(INTERNAL, SMALLINT, ANYARRAY, INTEGER, INTERNAL, INTERNAL, INTERNAL) RETURNS "char";
CREATE FUNCTION ginbeginscan(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION ginbuild(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION ginbuildempty(INTERNAL) RETURNS VOID;
CREATE FUNCTION ginbulkdelete(INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gincostestimate(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION ginendscan(INTERNAL) RETURNS VOID;
CREATE FUNCTION gingetbitmap(INTERNAL, INTERNAL) RETURNS BIGINT;
CREATE FUNCTION gininsert(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION ginmarkpos(INTERNAL) RETURNS VOID;
CREATE FUNCTION ginoptions(TEXT[], BOOLEAN) RETURNS BYTEA;
CREATE FUNCTION ginqueryarrayextract(ANYARRAY, INTERNAL, SMALLINT, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION ginrescan(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION ginrestrpos(INTERNAL) RETURNS VOID;
CREATE FUNCTION ginvacuumcleanup(INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gist_bbox_distance(INTERNAL, POINT, INTEGER, OID) RETURNS DOUBLE PRECISION;
CREATE FUNCTION gist_box_compress(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gist_box_consistent(INTERNAL, BOX, INTEGER, OID, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION gist_box_decompress(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gist_box_fetch(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gist_box_penalty(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gist_box_picksplit(INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gist_box_same(BOX, BOX, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gist_box_union(INTERNAL, INTERNAL) RETURNS BOX;
CREATE FUNCTION gist_circle_compress(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gist_circle_consistent(INTERNAL, CIRCLE, INTEGER, OID, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION gist_point_compress(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gist_point_consistent(INTERNAL, POINT, INTEGER, OID, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION gist_point_distance(INTERNAL, POINT, INTEGER, OID) RETURNS DOUBLE PRECISION;
CREATE FUNCTION gist_point_fetch(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gist_poly_compress(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gist_poly_consistent(INTERNAL, POLYGON, INTEGER, OID, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION gistbeginscan(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gistbuild(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gistbuildempty(INTERNAL) RETURNS VOID;
CREATE FUNCTION gistbulkdelete(INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gistcanreturn(INTERNAL, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION gistcostestimate(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION gistendscan(INTERNAL) RETURNS VOID;
CREATE FUNCTION gistgetbitmap(INTERNAL, INTERNAL) RETURNS BIGINT;
CREATE FUNCTION gistgettuple(INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION gistinsert(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION gistmarkpos(INTERNAL) RETURNS VOID;
CREATE FUNCTION gistoptions(TEXT[], BOOLEAN) RETURNS BYTEA;
CREATE FUNCTION gistrescan(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION gistrestrpos(INTERNAL) RETURNS VOID;
CREATE FUNCTION gistvacuumcleanup(INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gtsquery_compress(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gtsquery_consistent(INTERNAL, INTERNAL, INTEGER, OID, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION gtsquery_decompress(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gtsquery_penalty(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gtsquery_picksplit(INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gtsquery_same(BIGINT, BIGINT, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gtsquery_union(INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gtsvector_compress(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gtsvector_consistent(INTERNAL, GTSVECTOR, INTEGER, OID, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION gtsvector_decompress(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gtsvector_penalty(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gtsvector_picksplit(INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gtsvector_same(GTSVECTOR, GTSVECTOR, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gtsvector_union(INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION gtsvectorin(CSTRING) RETURNS GTSVECTOR;
CREATE FUNCTION gtsvectorout(GTSVECTOR) RETURNS CSTRING;
CREATE FUNCTION has_any_column_privilege(NAME, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_any_column_privilege(NAME, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_any_column_privilege(OID, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_any_column_privilege(OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_any_column_privilege(OID, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_any_column_privilege(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_column_privilege(NAME, OID, SMALLINT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_column_privilege(NAME, OID, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_column_privilege(NAME, TEXT, SMALLINT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_column_privilege(NAME, TEXT, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_column_privilege(OID, OID, SMALLINT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_column_privilege(OID, OID, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_column_privilege(OID, SMALLINT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_column_privilege(OID, TEXT, SMALLINT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_column_privilege(OID, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_column_privilege(OID, TEXT, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_column_privilege(TEXT, SMALLINT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_column_privilege(TEXT, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_database_privilege(NAME, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_database_privilege(NAME, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_database_privilege(OID, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_database_privilege(OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_database_privilege(OID, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_database_privilege(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_foreign_data_wrapper_privilege(NAME, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_foreign_data_wrapper_privilege(NAME, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_foreign_data_wrapper_privilege(OID, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_foreign_data_wrapper_privilege(OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_foreign_data_wrapper_privilege(OID, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_foreign_data_wrapper_privilege(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_function_privilege(NAME, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_function_privilege(NAME, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_function_privilege(OID, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_function_privilege(OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_function_privilege(OID, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_function_privilege(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_language_privilege(NAME, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_language_privilege(NAME, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_language_privilege(OID, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_language_privilege(OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_language_privilege(OID, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_language_privilege(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_schema_privilege(NAME, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_schema_privilege(NAME, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_schema_privilege(OID, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_schema_privilege(OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_schema_privilege(OID, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_schema_privilege(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_sequence_privilege(NAME, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_sequence_privilege(NAME, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_sequence_privilege(OID, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_sequence_privilege(OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_sequence_privilege(OID, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_sequence_privilege(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_server_privilege(NAME, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_server_privilege(NAME, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_server_privilege(OID, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_server_privilege(OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_server_privilege(OID, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_server_privilege(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_table_privilege(NAME, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_table_privilege(NAME, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_table_privilege(OID, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_table_privilege(OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_table_privilege(OID, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_table_privilege(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_tablespace_privilege(NAME, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_tablespace_privilege(NAME, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_tablespace_privilege(OID, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_tablespace_privilege(OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_tablespace_privilege(OID, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_tablespace_privilege(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_type_privilege(NAME, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_type_privilege(NAME, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_type_privilege(OID, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_type_privilege(OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_type_privilege(OID, TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION has_type_privilege(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION hash_aclitem(ACLITEM) RETURNS INTEGER;
CREATE FUNCTION hash_array(ANYARRAY) RETURNS INTEGER;
CREATE FUNCTION hash_numeric(NUMERIC) RETURNS INTEGER;
CREATE FUNCTION hash_range(ANYRANGE) RETURNS INTEGER;
CREATE FUNCTION hashbeginscan(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION hashbpchar(CHAR) RETURNS INTEGER;
CREATE FUNCTION hashbuild(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION hashbuildempty(INTERNAL) RETURNS VOID;
CREATE FUNCTION hashbulkdelete(INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION hashchar("char") RETURNS INTEGER;
CREATE FUNCTION hashcostestimate(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION hashendscan(INTERNAL) RETURNS VOID;
CREATE FUNCTION hashenum(ANYENUM) RETURNS INTEGER;
CREATE FUNCTION hashfloat4(REAL) RETURNS INTEGER;
CREATE FUNCTION hashfloat8(DOUBLE PRECISION) RETURNS INTEGER;
CREATE FUNCTION hashgetbitmap(INTERNAL, INTERNAL) RETURNS BIGINT;
CREATE FUNCTION hashgettuple(INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION hashinet(INET) RETURNS INTEGER;
CREATE FUNCTION hashinsert(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION hashint2(SMALLINT) RETURNS INTEGER;
CREATE FUNCTION hashint2vector(INT2VECTOR) RETURNS INTEGER;
CREATE FUNCTION hashint4(INTEGER) RETURNS INTEGER;
CREATE FUNCTION hashint8(BIGINT) RETURNS INTEGER;
CREATE FUNCTION hashmacaddr(MACADDR) RETURNS INTEGER;
CREATE FUNCTION hashmarkpos(INTERNAL) RETURNS VOID;
CREATE FUNCTION hashname(NAME) RETURNS INTEGER;
CREATE FUNCTION hashoid(OID) RETURNS INTEGER;
CREATE FUNCTION hashoidvector(OIDVECTOR) RETURNS INTEGER;
CREATE FUNCTION hashoptions(TEXT[], BOOLEAN) RETURNS BYTEA;
CREATE FUNCTION hashrescan(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION hashrestrpos(INTERNAL) RETURNS VOID;
CREATE FUNCTION hashtext(TEXT) RETURNS INTEGER;
CREATE FUNCTION hashvacuumcleanup(INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION hashvarlena(INTERNAL) RETURNS INTEGER;
CREATE FUNCTION height(BOX) RETURNS DOUBLE PRECISION;
CREATE FUNCTION host(INET) RETURNS TEXT;
CREATE FUNCTION hostmask(INET) RETURNS INET;
CREATE FUNCTION iclikejoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION iclikesel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION icnlikejoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION icnlikesel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION icregexeqjoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION icregexeqsel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION icregexnejoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION icregexnesel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION inet_client_addr() RETURNS INET;
CREATE FUNCTION inet_client_port() RETURNS INTEGER;
CREATE FUNCTION inet_gist_compress(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION inet_gist_consistent(INTERNAL, INET, INTEGER, OID, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION inet_gist_decompress(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION inet_gist_fetch(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION inet_gist_penalty(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION inet_gist_picksplit(INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION inet_gist_same(INET, INET, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION inet_gist_union(INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION inet_in(CSTRING) RETURNS INET;
CREATE FUNCTION inet_merge(INET, INET) RETURNS CIDR;
CREATE FUNCTION inet_out(INET) RETURNS CSTRING;
CREATE FUNCTION inet_recv(INTERNAL) RETURNS INET;
CREATE FUNCTION inet_same_family(INET, INET) RETURNS BOOLEAN;
CREATE FUNCTION inet_send(INET) RETURNS BYTEA;
CREATE FUNCTION inet_server_addr() RETURNS INET;
CREATE FUNCTION inet_server_port() RETURNS INTEGER;
CREATE FUNCTION inetand(INET, INET) RETURNS INET;
CREATE FUNCTION inetmi(INET, INET) RETURNS BIGINT;
CREATE FUNCTION inetmi_int8(INET, BIGINT) RETURNS INET;
CREATE FUNCTION inetnot(INET) RETURNS INET;
CREATE FUNCTION inetor(INET, INET) RETURNS INET;
CREATE FUNCTION inetpl(INET, BIGINT) RETURNS INET;
CREATE FUNCTION initcap(TEXT) RETURNS TEXT;
CREATE FUNCTION int2(BIGINT) RETURNS SMALLINT;
CREATE FUNCTION int2(DOUBLE PRECISION) RETURNS SMALLINT;
CREATE FUNCTION int2(INTEGER) RETURNS SMALLINT;
CREATE FUNCTION int2(NUMERIC) RETURNS SMALLINT;
CREATE FUNCTION int2(REAL) RETURNS SMALLINT;
CREATE FUNCTION int24div(SMALLINT, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int24eq(SMALLINT, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int24ge(SMALLINT, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int24gt(SMALLINT, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int24le(SMALLINT, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int24lt(SMALLINT, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int24mi(SMALLINT, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int24mul(SMALLINT, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int24ne(SMALLINT, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int24pl(SMALLINT, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int28div(SMALLINT, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int28eq(SMALLINT, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int28ge(SMALLINT, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int28gt(SMALLINT, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int28le(SMALLINT, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int28lt(SMALLINT, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int28mi(SMALLINT, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int28mul(SMALLINT, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int28ne(SMALLINT, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int28pl(SMALLINT, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int2_accum(INTERNAL, SMALLINT) RETURNS INTERNAL;
CREATE FUNCTION int2_accum_inv(INTERNAL, SMALLINT) RETURNS INTERNAL;
CREATE FUNCTION int2_avg_accum(BIGINT[], SMALLINT) RETURNS BIGINT[];
CREATE FUNCTION int2_avg_accum_inv(BIGINT[], SMALLINT) RETURNS BIGINT[];
CREATE FUNCTION int2_mul_cash(SMALLINT, MONEY) RETURNS MONEY;
CREATE FUNCTION int2_sum(BIGINT, SMALLINT) RETURNS BIGINT;
CREATE FUNCTION int2abs(SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION int2and(SMALLINT, SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION int2div(SMALLINT, SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION int2eq(SMALLINT, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int2ge(SMALLINT, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int2gt(SMALLINT, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int2in(CSTRING) RETURNS SMALLINT;
CREATE FUNCTION int2int4_sum(BIGINT[]) RETURNS BIGINT;
CREATE FUNCTION int2larger(SMALLINT, SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION int2le(SMALLINT, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int2lt(SMALLINT, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int2mi(SMALLINT, SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION int2mod(SMALLINT, SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION int2mul(SMALLINT, SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION int2ne(SMALLINT, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int2not(SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION int2or(SMALLINT, SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION int2out(SMALLINT) RETURNS CSTRING;
CREATE FUNCTION int2pl(SMALLINT, SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION int2recv(INTERNAL) RETURNS SMALLINT;
CREATE FUNCTION int2send(SMALLINT) RETURNS BYTEA;
CREATE FUNCTION int2shl(SMALLINT, INTEGER) RETURNS SMALLINT;
CREATE FUNCTION int2shr(SMALLINT, INTEGER) RETURNS SMALLINT;
CREATE FUNCTION int2smaller(SMALLINT, SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION int2um(SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION int2up(SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION int2vectoreq(INT2VECTOR, INT2VECTOR) RETURNS BOOLEAN;
CREATE FUNCTION int2vectorin(CSTRING) RETURNS INT2VECTOR;
CREATE FUNCTION int2vectorout(INT2VECTOR) RETURNS CSTRING;
CREATE FUNCTION int2vectorrecv(INTERNAL) RETURNS INT2VECTOR;
CREATE FUNCTION int2vectorsend(INT2VECTOR) RETURNS BYTEA;
CREATE FUNCTION int2xor(SMALLINT, SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION int4("char") RETURNS INTEGER;
CREATE FUNCTION int4(BIGINT) RETURNS INTEGER;
CREATE FUNCTION int4(BIT) RETURNS INTEGER;
CREATE FUNCTION int4(BOOLEAN) RETURNS INTEGER;
CREATE FUNCTION int4(DOUBLE PRECISION) RETURNS INTEGER;
CREATE FUNCTION int4(NUMERIC) RETURNS INTEGER;
CREATE FUNCTION int4(REAL) RETURNS INTEGER;
CREATE FUNCTION int4(SMALLINT) RETURNS INTEGER;
CREATE FUNCTION int42div(INTEGER, SMALLINT) RETURNS INTEGER;
CREATE FUNCTION int42eq(INTEGER, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int42ge(INTEGER, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int42gt(INTEGER, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int42le(INTEGER, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int42lt(INTEGER, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int42mi(INTEGER, SMALLINT) RETURNS INTEGER;
CREATE FUNCTION int42mul(INTEGER, SMALLINT) RETURNS INTEGER;
CREATE FUNCTION int42ne(INTEGER, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int42pl(INTEGER, SMALLINT) RETURNS INTEGER;
CREATE FUNCTION int48div(INTEGER, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int48eq(INTEGER, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int48ge(INTEGER, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int48gt(INTEGER, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int48le(INTEGER, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int48lt(INTEGER, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int48mi(INTEGER, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int48mul(INTEGER, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int48ne(INTEGER, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int48pl(INTEGER, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int4_accum(INTERNAL, INTEGER) RETURNS INTERNAL;
CREATE FUNCTION int4_accum_inv(INTERNAL, INTEGER) RETURNS INTERNAL;
CREATE FUNCTION int4_avg_accum(BIGINT[], INTEGER) RETURNS BIGINT[];
CREATE FUNCTION int4_avg_accum_inv(BIGINT[], INTEGER) RETURNS BIGINT[];
CREATE FUNCTION int4_mul_cash(INTEGER, MONEY) RETURNS MONEY;
CREATE FUNCTION int4_sum(BIGINT, INTEGER) RETURNS BIGINT;
CREATE FUNCTION int4abs(INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4and(INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4div(INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4eq(INTEGER, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int4ge(INTEGER, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int4gt(INTEGER, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int4in(CSTRING) RETURNS INTEGER;
CREATE FUNCTION int4inc(INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4larger(INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4le(INTEGER, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int4lt(INTEGER, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int4mi(INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4mod(INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4mul(INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4ne(INTEGER, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int4not(INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4or(INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4out(INTEGER) RETURNS CSTRING;
CREATE FUNCTION int4pl(INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4range(INTEGER, INTEGER) RETURNS INT4RANGE;
CREATE FUNCTION int4range(INTEGER, INTEGER, TEXT) RETURNS INT4RANGE;
CREATE FUNCTION int4range_canonical(INT4RANGE) RETURNS INT4RANGE;
CREATE FUNCTION int4range_subdiff(INTEGER, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION int4recv(INTERNAL) RETURNS INTEGER;
CREATE FUNCTION int4send(INTEGER) RETURNS BYTEA;
CREATE FUNCTION int4shl(INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4shr(INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4smaller(INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4um(INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4up(INTEGER) RETURNS INTEGER;
CREATE FUNCTION int4xor(INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION int8(BIT) RETURNS BIGINT;
CREATE FUNCTION int8(DOUBLE PRECISION) RETURNS BIGINT;
CREATE FUNCTION int8(INTEGER) RETURNS BIGINT;
CREATE FUNCTION int8(NUMERIC) RETURNS BIGINT;
CREATE FUNCTION int8(OID) RETURNS BIGINT;
CREATE FUNCTION int8(REAL) RETURNS BIGINT;
CREATE FUNCTION int8(SMALLINT) RETURNS BIGINT;
CREATE FUNCTION int82div(BIGINT, SMALLINT) RETURNS BIGINT;
CREATE FUNCTION int82eq(BIGINT, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int82ge(BIGINT, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int82gt(BIGINT, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int82le(BIGINT, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int82lt(BIGINT, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int82mi(BIGINT, SMALLINT) RETURNS BIGINT;
CREATE FUNCTION int82mul(BIGINT, SMALLINT) RETURNS BIGINT;
CREATE FUNCTION int82ne(BIGINT, SMALLINT) RETURNS BOOLEAN;
CREATE FUNCTION int82pl(BIGINT, SMALLINT) RETURNS BIGINT;
CREATE FUNCTION int84div(BIGINT, INTEGER) RETURNS BIGINT;
CREATE FUNCTION int84eq(BIGINT, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int84ge(BIGINT, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int84gt(BIGINT, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int84le(BIGINT, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int84lt(BIGINT, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int84mi(BIGINT, INTEGER) RETURNS BIGINT;
CREATE FUNCTION int84mul(BIGINT, INTEGER) RETURNS BIGINT;
CREATE FUNCTION int84ne(BIGINT, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION int84pl(BIGINT, INTEGER) RETURNS BIGINT;
CREATE FUNCTION int8_accum(INTERNAL, BIGINT) RETURNS INTERNAL;
CREATE FUNCTION int8_accum_inv(INTERNAL, BIGINT) RETURNS INTERNAL;
CREATE FUNCTION int8_avg(BIGINT[]) RETURNS NUMERIC;
CREATE FUNCTION int8_avg_accum(INTERNAL, BIGINT) RETURNS INTERNAL;
CREATE FUNCTION int8_avg_accum_inv(INTERNAL, BIGINT) RETURNS INTERNAL;
CREATE FUNCTION int8_sum(NUMERIC, BIGINT) RETURNS NUMERIC;
CREATE FUNCTION int8abs(BIGINT) RETURNS BIGINT;
CREATE FUNCTION int8and(BIGINT, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int8dec(BIGINT) RETURNS BIGINT;
CREATE FUNCTION int8dec_any(BIGINT, "any") RETURNS BIGINT;
CREATE FUNCTION int8div(BIGINT, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int8eq(BIGINT, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int8ge(BIGINT, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int8gt(BIGINT, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int8in(CSTRING) RETURNS BIGINT;
CREATE FUNCTION int8inc(BIGINT) RETURNS BIGINT;
CREATE FUNCTION int8inc_any(BIGINT, "any") RETURNS BIGINT;
CREATE FUNCTION int8inc_float8_float8(BIGINT, DOUBLE PRECISION, DOUBLE PRECISION) RETURNS BIGINT;
CREATE FUNCTION int8larger(BIGINT, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int8le(BIGINT, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int8lt(BIGINT, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int8mi(BIGINT, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int8mod(BIGINT, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int8mul(BIGINT, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int8ne(BIGINT, BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION int8not(BIGINT) RETURNS BIGINT;
CREATE FUNCTION int8or(BIGINT, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int8out(BIGINT) RETURNS CSTRING;
CREATE FUNCTION int8pl(BIGINT, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int8pl_inet(BIGINT, INET) RETURNS INET;
CREATE FUNCTION int8range(BIGINT, BIGINT) RETURNS INT8RANGE;
CREATE FUNCTION int8range(BIGINT, BIGINT, TEXT) RETURNS INT8RANGE;
CREATE FUNCTION int8range_canonical(INT8RANGE) RETURNS INT8RANGE;
CREATE FUNCTION int8range_subdiff(BIGINT, BIGINT) RETURNS DOUBLE PRECISION;
CREATE FUNCTION int8recv(INTERNAL) RETURNS BIGINT;
CREATE FUNCTION int8send(BIGINT) RETURNS BYTEA;
CREATE FUNCTION int8shl(BIGINT, INTEGER) RETURNS BIGINT;
CREATE FUNCTION int8shr(BIGINT, INTEGER) RETURNS BIGINT;
CREATE FUNCTION int8smaller(BIGINT, BIGINT) RETURNS BIGINT;
CREATE FUNCTION int8um(BIGINT) RETURNS BIGINT;
CREATE FUNCTION int8up(BIGINT) RETURNS BIGINT;
CREATE FUNCTION int8xor(BIGINT, BIGINT) RETURNS BIGINT;
CREATE FUNCTION integer_pl_date(INTEGER, DATE) RETURNS DATE;
CREATE FUNCTION inter_lb(LINE, BOX) RETURNS BOOLEAN;
CREATE FUNCTION inter_sb(LSEG, BOX) RETURNS BOOLEAN;
CREATE FUNCTION inter_sl(LSEG, LINE) RETURNS BOOLEAN;
CREATE FUNCTION internal_in(CSTRING) RETURNS INTERNAL;
CREATE FUNCTION internal_out(INTERNAL) RETURNS CSTRING;
CREATE FUNCTION interval(INTERVAL, INTEGER) RETURNS INTERVAL;
CREATE FUNCTION interval(RELTIME) RETURNS INTERVAL;
CREATE FUNCTION interval(TIME) RETURNS INTERVAL;
CREATE FUNCTION interval_accum(INTERVAL[], INTERVAL) RETURNS INTERVAL[];
CREATE FUNCTION interval_accum_inv(INTERVAL[], INTERVAL) RETURNS INTERVAL[];
CREATE FUNCTION interval_avg(INTERVAL[]) RETURNS INTERVAL;
CREATE FUNCTION interval_cmp(INTERVAL, INTERVAL) RETURNS INTEGER;
CREATE FUNCTION interval_div(INTERVAL, DOUBLE PRECISION) RETURNS INTERVAL;
CREATE FUNCTION interval_eq(INTERVAL, INTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION interval_ge(INTERVAL, INTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION interval_gt(INTERVAL, INTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION interval_hash(INTERVAL) RETURNS INTEGER;
CREATE FUNCTION interval_in(CSTRING, OID, INTEGER) RETURNS INTERVAL;
CREATE FUNCTION interval_larger(INTERVAL, INTERVAL) RETURNS INTERVAL;
CREATE FUNCTION interval_le(INTERVAL, INTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION interval_lt(INTERVAL, INTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION interval_mi(INTERVAL, INTERVAL) RETURNS INTERVAL;
CREATE FUNCTION interval_mul(INTERVAL, DOUBLE PRECISION) RETURNS INTERVAL;
CREATE FUNCTION interval_ne(INTERVAL, INTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION interval_out(INTERVAL) RETURNS CSTRING;
CREATE FUNCTION interval_pl(INTERVAL, INTERVAL) RETURNS INTERVAL;
CREATE FUNCTION interval_pl_date(INTERVAL, DATE) RETURNS TIMESTAMP;
CREATE FUNCTION interval_pl_time(INTERVAL, TIME) RETURNS TIME;
CREATE FUNCTION interval_pl_timestamp(INTERVAL, TIMESTAMP) RETURNS TIMESTAMP;
CREATE FUNCTION interval_pl_timestamptz(INTERVAL, TIMESTAMP WITH TIME ZONE) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION interval_pl_timetz(INTERVAL, TIME WITH TIME ZONE) RETURNS TIME WITH TIME ZONE;
CREATE FUNCTION interval_recv(INTERNAL, OID, INTEGER) RETURNS INTERVAL;
CREATE FUNCTION interval_send(INTERVAL) RETURNS BYTEA;
CREATE FUNCTION interval_smaller(INTERVAL, INTERVAL) RETURNS INTERVAL;
CREATE FUNCTION interval_transform(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION interval_um(INTERVAL) RETURNS INTERVAL;
CREATE FUNCTION intervaltypmodin(CSTRING[]) RETURNS INTEGER;
CREATE FUNCTION intervaltypmodout(INTEGER) RETURNS CSTRING;
CREATE FUNCTION intinterval(ABSTIME, TINTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION isclosed(PATH) RETURNS BOOLEAN;
CREATE FUNCTION isempty(ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION isfinite(ABSTIME) RETURNS BOOLEAN;
CREATE FUNCTION isfinite(DATE) RETURNS BOOLEAN;
CREATE FUNCTION isfinite(INTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION isfinite(TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION isfinite(TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION ishorizontal(LINE) RETURNS BOOLEAN;
CREATE FUNCTION ishorizontal(LSEG) RETURNS BOOLEAN;
CREATE FUNCTION ishorizontal(POINT, POINT) RETURNS BOOLEAN;
CREATE FUNCTION iso8859_1_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION iso8859_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION iso_to_koi8r(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION iso_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION iso_to_win1251(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION iso_to_win866(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION isopen(PATH) RETURNS BOOLEAN;
CREATE FUNCTION isparallel(LINE, LINE) RETURNS BOOLEAN;
CREATE FUNCTION isparallel(LSEG, LSEG) RETURNS BOOLEAN;
CREATE FUNCTION isperp(LINE, LINE) RETURNS BOOLEAN;
CREATE FUNCTION isperp(LSEG, LSEG) RETURNS BOOLEAN;
CREATE FUNCTION isvertical(LINE) RETURNS BOOLEAN;
CREATE FUNCTION isvertical(LSEG) RETURNS BOOLEAN;
CREATE FUNCTION isvertical(POINT, POINT) RETURNS BOOLEAN;
CREATE FUNCTION johab_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION json_agg(ANYELEMENT) RETURNS JSON;
CREATE FUNCTION json_agg_finalfn(INTERNAL) RETURNS JSON;
CREATE FUNCTION json_agg_transfn(INTERNAL, ANYELEMENT) RETURNS INTERNAL;
CREATE FUNCTION json_array_element(from_json JSON, element_index INTEGER) RETURNS JSON;
CREATE FUNCTION json_array_element_text(from_json JSON, element_index INTEGER) RETURNS TEXT;
CREATE FUNCTION json_array_elements(from_json JSON, value OUT JSON) RETURNS SETOF JSON;
CREATE FUNCTION json_array_elements_text(from_json JSON, value OUT TEXT) RETURNS SETOF TEXT;
CREATE FUNCTION json_array_length(JSON) RETURNS INTEGER;
CREATE FUNCTION json_build_array("any") RETURNS JSON;
CREATE FUNCTION json_build_array() RETURNS JSON;
CREATE FUNCTION json_build_object("any") RETURNS JSON;
CREATE FUNCTION json_build_object() RETURNS JSON;
CREATE FUNCTION json_each(from_json JSON, key OUT TEXT, value OUT JSON) RETURNS SETOF RECORD;
CREATE FUNCTION json_each_text(from_json JSON, key OUT TEXT, value OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION json_extract_path(from_json JSON, path_elems TEXT[]) RETURNS JSON;
CREATE FUNCTION json_extract_path_text(from_json JSON, path_elems TEXT[]) RETURNS TEXT;
CREATE FUNCTION json_in(CSTRING) RETURNS JSON;
CREATE FUNCTION json_object(TEXT[]) RETURNS JSON;
CREATE FUNCTION json_object(TEXT[], TEXT[]) RETURNS JSON;
CREATE FUNCTION json_object_agg("any", "any") RETURNS JSON;
CREATE FUNCTION json_object_agg_finalfn(INTERNAL) RETURNS JSON;
CREATE FUNCTION json_object_agg_transfn(INTERNAL, "any", "any") RETURNS INTERNAL;
CREATE FUNCTION json_object_field(from_json JSON, field_name TEXT) RETURNS JSON;
CREATE FUNCTION json_object_field_text(from_json JSON, field_name TEXT) RETURNS TEXT;
CREATE FUNCTION json_object_keys(JSON) RETURNS SETOF TEXT;
CREATE FUNCTION json_out(JSON) RETURNS CSTRING;
CREATE FUNCTION json_populate_record(base ANYELEMENT, from_json JSON, use_json_as_text BOOLEAN) RETURNS ANYELEMENT;
CREATE FUNCTION json_populate_recordset(base ANYELEMENT, from_json JSON, use_json_as_text BOOLEAN) RETURNS SETOF ANYELEMENT;
CREATE FUNCTION json_recv(INTERNAL) RETURNS JSON;
CREATE FUNCTION json_send(JSON) RETURNS BYTEA;
CREATE FUNCTION json_strip_nulls(JSON) RETURNS JSON;
CREATE FUNCTION json_to_record(JSON) RETURNS RECORD;
CREATE FUNCTION json_to_recordset(JSON) RETURNS SETOF RECORD;
CREATE FUNCTION json_typeof(JSON) RETURNS TEXT;
CREATE FUNCTION jsonb_agg(ANYELEMENT) RETURNS JSONB;
CREATE FUNCTION jsonb_agg_finalfn(INTERNAL) RETURNS JSONB;
CREATE FUNCTION jsonb_agg_transfn(INTERNAL, ANYELEMENT) RETURNS INTERNAL;
CREATE FUNCTION jsonb_array_element(from_json JSONB, element_index INTEGER) RETURNS JSONB;
CREATE FUNCTION jsonb_array_element_text(from_json JSONB, element_index INTEGER) RETURNS TEXT;
CREATE FUNCTION jsonb_array_elements(from_json JSONB, value OUT JSONB) RETURNS SETOF JSONB;
CREATE FUNCTION jsonb_array_elements_text(from_json JSONB, value OUT TEXT) RETURNS SETOF TEXT;
CREATE FUNCTION jsonb_array_length(JSONB) RETURNS INTEGER;
CREATE FUNCTION jsonb_build_array("any") RETURNS JSONB;
CREATE FUNCTION jsonb_build_array() RETURNS JSONB;
CREATE FUNCTION jsonb_build_object("any") RETURNS JSONB;
CREATE FUNCTION jsonb_build_object() RETURNS JSONB;
CREATE FUNCTION jsonb_cmp(JSONB, JSONB) RETURNS INTEGER;
CREATE FUNCTION jsonb_concat(JSONB, JSONB) RETURNS JSONB;
CREATE FUNCTION jsonb_contained(JSONB, JSONB) RETURNS BOOLEAN;
CREATE FUNCTION jsonb_contains(JSONB, JSONB) RETURNS BOOLEAN;
CREATE FUNCTION jsonb_delete(JSONB, INTEGER) RETURNS JSONB;
CREATE FUNCTION jsonb_delete(JSONB, TEXT) RETURNS JSONB;
CREATE FUNCTION jsonb_delete_path(JSONB, TEXT[]) RETURNS JSONB;
CREATE FUNCTION jsonb_each(from_json JSONB, key OUT TEXT, value OUT JSONB) RETURNS SETOF RECORD;
CREATE FUNCTION jsonb_each_text(from_json JSONB, key OUT TEXT, value OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION jsonb_eq(JSONB, JSONB) RETURNS BOOLEAN;
CREATE FUNCTION jsonb_exists(JSONB, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION jsonb_exists_all(JSONB, TEXT[]) RETURNS BOOLEAN;
CREATE FUNCTION jsonb_exists_any(JSONB, TEXT[]) RETURNS BOOLEAN;
CREATE FUNCTION jsonb_extract_path(from_json JSONB, path_elems TEXT[]) RETURNS JSONB;
CREATE FUNCTION jsonb_extract_path_text(from_json JSONB, path_elems TEXT[]) RETURNS TEXT;
CREATE FUNCTION jsonb_ge(JSONB, JSONB) RETURNS BOOLEAN;
CREATE FUNCTION jsonb_gt(JSONB, JSONB) RETURNS BOOLEAN;
CREATE FUNCTION jsonb_hash(JSONB) RETURNS INTEGER;
CREATE FUNCTION jsonb_in(CSTRING) RETURNS JSONB;
CREATE FUNCTION jsonb_le(JSONB, JSONB) RETURNS BOOLEAN;
CREATE FUNCTION jsonb_lt(JSONB, JSONB) RETURNS BOOLEAN;
CREATE FUNCTION jsonb_ne(JSONB, JSONB) RETURNS BOOLEAN;
CREATE FUNCTION jsonb_object(TEXT[]) RETURNS JSONB;
CREATE FUNCTION jsonb_object(TEXT[], TEXT[]) RETURNS JSONB;
CREATE FUNCTION jsonb_object_agg("any", "any") RETURNS JSONB;
CREATE FUNCTION jsonb_object_agg_finalfn(INTERNAL) RETURNS JSONB;
CREATE FUNCTION jsonb_object_agg_transfn(INTERNAL, "any", "any") RETURNS INTERNAL;
CREATE FUNCTION jsonb_object_field(from_json JSONB, field_name TEXT) RETURNS JSONB;
CREATE FUNCTION jsonb_object_field_text(from_json JSONB, field_name TEXT) RETURNS TEXT;
CREATE FUNCTION jsonb_object_keys(JSONB) RETURNS SETOF TEXT;
CREATE FUNCTION jsonb_out(JSONB) RETURNS CSTRING;
CREATE FUNCTION jsonb_populate_record(ANYELEMENT, JSONB) RETURNS ANYELEMENT;
CREATE FUNCTION jsonb_populate_recordset(ANYELEMENT, JSONB) RETURNS SETOF ANYELEMENT;
CREATE FUNCTION jsonb_pretty(JSONB) RETURNS TEXT;
CREATE FUNCTION jsonb_recv(INTERNAL) RETURNS JSONB;
CREATE FUNCTION jsonb_send(JSONB) RETURNS BYTEA;
CREATE FUNCTION jsonb_set(jsonb_in JSONB, path TEXT[], replacement JSONB, create_if_missing BOOLEAN) RETURNS JSONB;
CREATE FUNCTION jsonb_strip_nulls(JSONB) RETURNS JSONB;
CREATE FUNCTION jsonb_to_record(JSONB) RETURNS RECORD;
CREATE FUNCTION jsonb_to_recordset(JSONB) RETURNS SETOF RECORD;
CREATE FUNCTION jsonb_typeof(JSONB) RETURNS TEXT;
CREATE FUNCTION justify_days(INTERVAL) RETURNS INTERVAL;
CREATE FUNCTION justify_hours(INTERVAL) RETURNS INTERVAL;
CREATE FUNCTION justify_interval(INTERVAL) RETURNS INTERVAL;
CREATE FUNCTION koi8r_to_iso(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION koi8r_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION koi8r_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION koi8r_to_win1251(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION koi8r_to_win866(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION koi8u_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION lag(ANYELEMENT) RETURNS ANYELEMENT;
CREATE FUNCTION lag(ANYELEMENT, INTEGER) RETURNS ANYELEMENT;
CREATE FUNCTION lag(ANYELEMENT, INTEGER, ANYELEMENT) RETURNS ANYELEMENT;
CREATE FUNCTION language_handler_in(CSTRING) RETURNS LANGUAGE_HANDLER;
CREATE FUNCTION language_handler_out(LANGUAGE_HANDLER) RETURNS CSTRING;
CREATE FUNCTION last_value(ANYELEMENT) RETURNS ANYELEMENT;
CREATE FUNCTION lastval() RETURNS BIGINT;
CREATE FUNCTION latin1_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION latin2_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION latin2_to_win1250(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION latin3_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION latin4_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION lead(ANYELEMENT) RETURNS ANYELEMENT;
CREATE FUNCTION lead(ANYELEMENT, INTEGER) RETURNS ANYELEMENT;
CREATE FUNCTION lead(ANYELEMENT, INTEGER, ANYELEMENT) RETURNS ANYELEMENT;
CREATE FUNCTION "left"(TEXT, INTEGER) RETURNS TEXT;
CREATE FUNCTION length(BIT) RETURNS INTEGER;
CREATE FUNCTION length(BYTEA) RETURNS INTEGER;
CREATE FUNCTION length(BYTEA, NAME) RETURNS INTEGER;
CREATE FUNCTION length(CHAR) RETURNS INTEGER;
CREATE FUNCTION length(LSEG) RETURNS DOUBLE PRECISION;
CREATE FUNCTION length(PATH) RETURNS DOUBLE PRECISION;
CREATE FUNCTION length(TEXT) RETURNS INTEGER;
CREATE FUNCTION length(TSVECTOR) RETURNS INTEGER;
CREATE FUNCTION "like"(BYTEA, BYTEA) RETURNS BOOLEAN;
CREATE FUNCTION "like"(NAME, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION "like"(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION like_escape(BYTEA, BYTEA) RETURNS BYTEA;
CREATE FUNCTION like_escape(TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION likejoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION likesel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION line(POINT, POINT) RETURNS LINE;
CREATE FUNCTION line_distance(LINE, LINE) RETURNS DOUBLE PRECISION;
CREATE FUNCTION line_eq(LINE, LINE) RETURNS BOOLEAN;
CREATE FUNCTION line_horizontal(LINE) RETURNS BOOLEAN;
CREATE FUNCTION line_in(CSTRING) RETURNS LINE;
CREATE FUNCTION line_interpt(LINE, LINE) RETURNS POINT;
CREATE FUNCTION line_intersect(LINE, LINE) RETURNS BOOLEAN;
CREATE FUNCTION line_out(LINE) RETURNS CSTRING;
CREATE FUNCTION line_parallel(LINE, LINE) RETURNS BOOLEAN;
CREATE FUNCTION line_perp(LINE, LINE) RETURNS BOOLEAN;
CREATE FUNCTION line_recv(INTERNAL) RETURNS LINE;
CREATE FUNCTION line_send(LINE) RETURNS BYTEA;
CREATE FUNCTION line_vertical(LINE) RETURNS BOOLEAN;
CREATE FUNCTION ln(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION ln(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION lo_close(INTEGER) RETURNS INTEGER;
CREATE FUNCTION lo_creat(INTEGER) RETURNS OID;
CREATE FUNCTION lo_create(OID) RETURNS OID;
CREATE FUNCTION lo_export(OID, TEXT) RETURNS INTEGER;
CREATE FUNCTION lo_from_bytea(OID, BYTEA) RETURNS OID;
CREATE FUNCTION lo_get(OID) RETURNS BYTEA;
CREATE FUNCTION lo_get(OID, BIGINT, INTEGER) RETURNS BYTEA;
CREATE FUNCTION lo_import(TEXT) RETURNS OID;
CREATE FUNCTION lo_import(TEXT, OID) RETURNS OID;
CREATE FUNCTION lo_lseek(INTEGER, INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION lo_lseek64(INTEGER, BIGINT, INTEGER) RETURNS BIGINT;
CREATE FUNCTION lo_open(OID, INTEGER) RETURNS INTEGER;
CREATE FUNCTION lo_put(OID, BIGINT, BYTEA) RETURNS VOID;
CREATE FUNCTION lo_tell(INTEGER) RETURNS INTEGER;
CREATE FUNCTION lo_tell64(INTEGER) RETURNS BIGINT;
CREATE FUNCTION lo_truncate(INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION lo_truncate64(INTEGER, BIGINT) RETURNS INTEGER;
CREATE FUNCTION lo_unlink(OID) RETURNS INTEGER;
CREATE FUNCTION log(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION log(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION log(NUMERIC, NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION loread(INTEGER, INTEGER) RETURNS BYTEA;
CREATE FUNCTION lower(ANYRANGE) RETURNS ANYELEMENT;
CREATE FUNCTION lower(TEXT) RETURNS TEXT;
CREATE FUNCTION lower_inc(ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION lower_inf(ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION lowrite(INTEGER, BYTEA) RETURNS INTEGER;
CREATE FUNCTION lpad(TEXT, INTEGER) RETURNS TEXT;
CREATE FUNCTION lpad(TEXT, INTEGER, TEXT) RETURNS TEXT;
CREATE FUNCTION lseg(BOX) RETURNS LSEG;
CREATE FUNCTION lseg(POINT, POINT) RETURNS LSEG;
CREATE FUNCTION lseg_center(LSEG) RETURNS POINT;
CREATE FUNCTION lseg_distance(LSEG, LSEG) RETURNS DOUBLE PRECISION;
CREATE FUNCTION lseg_eq(LSEG, LSEG) RETURNS BOOLEAN;
CREATE FUNCTION lseg_ge(LSEG, LSEG) RETURNS BOOLEAN;
CREATE FUNCTION lseg_gt(LSEG, LSEG) RETURNS BOOLEAN;
CREATE FUNCTION lseg_horizontal(LSEG) RETURNS BOOLEAN;
CREATE FUNCTION lseg_in(CSTRING) RETURNS LSEG;
CREATE FUNCTION lseg_interpt(LSEG, LSEG) RETURNS POINT;
CREATE FUNCTION lseg_intersect(LSEG, LSEG) RETURNS BOOLEAN;
CREATE FUNCTION lseg_le(LSEG, LSEG) RETURNS BOOLEAN;
CREATE FUNCTION lseg_length(LSEG) RETURNS DOUBLE PRECISION;
CREATE FUNCTION lseg_lt(LSEG, LSEG) RETURNS BOOLEAN;
CREATE FUNCTION lseg_ne(LSEG, LSEG) RETURNS BOOLEAN;
CREATE FUNCTION lseg_out(LSEG) RETURNS CSTRING;
CREATE FUNCTION lseg_parallel(LSEG, LSEG) RETURNS BOOLEAN;
CREATE FUNCTION lseg_perp(LSEG, LSEG) RETURNS BOOLEAN;
CREATE FUNCTION lseg_recv(INTERNAL) RETURNS LSEG;
CREATE FUNCTION lseg_send(LSEG) RETURNS BYTEA;
CREATE FUNCTION lseg_vertical(LSEG) RETURNS BOOLEAN;
CREATE FUNCTION ltrim(TEXT) RETURNS TEXT;
CREATE FUNCTION ltrim(TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION macaddr_and(MACADDR, MACADDR) RETURNS MACADDR;
CREATE FUNCTION macaddr_cmp(MACADDR, MACADDR) RETURNS INTEGER;
CREATE FUNCTION macaddr_eq(MACADDR, MACADDR) RETURNS BOOLEAN;
CREATE FUNCTION macaddr_ge(MACADDR, MACADDR) RETURNS BOOLEAN;
CREATE FUNCTION macaddr_gt(MACADDR, MACADDR) RETURNS BOOLEAN;
CREATE FUNCTION macaddr_in(CSTRING) RETURNS MACADDR;
CREATE FUNCTION macaddr_le(MACADDR, MACADDR) RETURNS BOOLEAN;
CREATE FUNCTION macaddr_lt(MACADDR, MACADDR) RETURNS BOOLEAN;
CREATE FUNCTION macaddr_ne(MACADDR, MACADDR) RETURNS BOOLEAN;
CREATE FUNCTION macaddr_not(MACADDR) RETURNS MACADDR;
CREATE FUNCTION macaddr_or(MACADDR, MACADDR) RETURNS MACADDR;
CREATE FUNCTION macaddr_out(MACADDR) RETURNS CSTRING;
CREATE FUNCTION macaddr_recv(INTERNAL) RETURNS MACADDR;
CREATE FUNCTION macaddr_send(MACADDR) RETURNS BYTEA;
CREATE FUNCTION make_date(year INTEGER, month INTEGER, day INTEGER) RETURNS DATE;
CREATE FUNCTION make_interval(years INTEGER, months INTEGER, weeks INTEGER, days INTEGER, hours INTEGER, mins INTEGER, secs DOUBLE PRECISION) RETURNS INTERVAL;
CREATE FUNCTION make_time(hour INTEGER, min INTEGER, sec DOUBLE PRECISION) RETURNS TIME;
CREATE FUNCTION make_timestamp(year INTEGER, month INTEGER, mday INTEGER, hour INTEGER, min INTEGER, sec DOUBLE PRECISION) RETURNS TIMESTAMP;
CREATE FUNCTION make_timestamptz(year INTEGER, month INTEGER, mday INTEGER, hour INTEGER, min INTEGER, sec DOUBLE PRECISION) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION make_timestamptz(year INTEGER, month INTEGER, mday INTEGER, hour INTEGER, min INTEGER, sec DOUBLE PRECISION, timezone TEXT) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION makeaclitem(OID, OID, TEXT, BOOLEAN) RETURNS ACLITEM;
CREATE FUNCTION masklen(INET) RETURNS INTEGER;
CREATE FUNCTION max(ABSTIME) RETURNS ABSTIME;
CREATE FUNCTION max(ANYARRAY) RETURNS ANYARRAY;
CREATE FUNCTION max(ANYENUM) RETURNS ANYENUM;
CREATE FUNCTION max(BIGINT) RETURNS BIGINT;
CREATE FUNCTION max(CHAR) RETURNS CHAR;
CREATE FUNCTION max(DATE) RETURNS DATE;
CREATE FUNCTION max(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION max(INET) RETURNS INET;
CREATE FUNCTION max(INTEGER) RETURNS INTEGER;
CREATE FUNCTION max(INTERVAL) RETURNS INTERVAL;
CREATE FUNCTION max(MONEY) RETURNS MONEY;
CREATE FUNCTION max(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION max(OID) RETURNS OID;
CREATE FUNCTION max(REAL) RETURNS REAL;
CREATE FUNCTION max(SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION max(TEXT) RETURNS TEXT;
CREATE FUNCTION max(TID) RETURNS TID;
CREATE FUNCTION max(TIME WITH TIME ZONE) RETURNS TIME WITH TIME ZONE;
CREATE FUNCTION max(TIME) RETURNS TIME;
CREATE FUNCTION max(TIMESTAMP WITH TIME ZONE) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION max(TIMESTAMP) RETURNS TIMESTAMP;
CREATE FUNCTION md5(BYTEA) RETURNS TEXT;
CREATE FUNCTION md5(TEXT) RETURNS TEXT;
CREATE FUNCTION mic_to_ascii(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION mic_to_big5(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION mic_to_euc_cn(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION mic_to_euc_jp(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION mic_to_euc_kr(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION mic_to_euc_tw(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION mic_to_iso(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION mic_to_koi8r(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION mic_to_latin1(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION mic_to_latin2(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION mic_to_latin3(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION mic_to_latin4(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION mic_to_sjis(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION mic_to_win1250(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION mic_to_win1251(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION mic_to_win866(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION min(ABSTIME) RETURNS ABSTIME;
CREATE FUNCTION min(ANYARRAY) RETURNS ANYARRAY;
CREATE FUNCTION min(ANYENUM) RETURNS ANYENUM;
CREATE FUNCTION min(BIGINT) RETURNS BIGINT;
CREATE FUNCTION min(CHAR) RETURNS CHAR;
CREATE FUNCTION min(DATE) RETURNS DATE;
CREATE FUNCTION min(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION min(INET) RETURNS INET;
CREATE FUNCTION min(INTEGER) RETURNS INTEGER;
CREATE FUNCTION min(INTERVAL) RETURNS INTERVAL;
CREATE FUNCTION min(MONEY) RETURNS MONEY;
CREATE FUNCTION min(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION min(OID) RETURNS OID;
CREATE FUNCTION min(REAL) RETURNS REAL;
CREATE FUNCTION min(SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION min(TEXT) RETURNS TEXT;
CREATE FUNCTION min(TID) RETURNS TID;
CREATE FUNCTION min(TIME WITH TIME ZONE) RETURNS TIME WITH TIME ZONE;
CREATE FUNCTION min(TIME) RETURNS TIME;
CREATE FUNCTION min(TIMESTAMP WITH TIME ZONE) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION min(TIMESTAMP) RETURNS TIMESTAMP;
CREATE FUNCTION mktinterval(ABSTIME, ABSTIME) RETURNS TINTERVAL;
CREATE FUNCTION mod(BIGINT, BIGINT) RETURNS BIGINT;
CREATE FUNCTION mod(INTEGER, INTEGER) RETURNS INTEGER;
CREATE FUNCTION mod(NUMERIC, NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION mod(SMALLINT, SMALLINT) RETURNS SMALLINT;
CREATE FUNCTION mode(ANYELEMENT) RETURNS ANYELEMENT;
CREATE FUNCTION mode_final(INTERNAL, ANYELEMENT) RETURNS ANYELEMENT;
CREATE FUNCTION money(BIGINT) RETURNS MONEY;
CREATE FUNCTION money(INTEGER) RETURNS MONEY;
CREATE FUNCTION money(NUMERIC) RETURNS MONEY;
CREATE FUNCTION mul_d_interval(DOUBLE PRECISION, INTERVAL) RETURNS INTERVAL;
CREATE FUNCTION mxid_age(XID) RETURNS INTEGER;
CREATE FUNCTION name(CHAR) RETURNS NAME;
CREATE FUNCTION name(TEXT) RETURNS NAME;
CREATE FUNCTION name(VARCHAR) RETURNS NAME;
CREATE FUNCTION nameeq(NAME, NAME) RETURNS BOOLEAN;
CREATE FUNCTION namege(NAME, NAME) RETURNS BOOLEAN;
CREATE FUNCTION namegt(NAME, NAME) RETURNS BOOLEAN;
CREATE FUNCTION nameiclike(NAME, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION nameicnlike(NAME, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION nameicregexeq(NAME, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION nameicregexne(NAME, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION namein(CSTRING) RETURNS NAME;
CREATE FUNCTION namele(NAME, NAME) RETURNS BOOLEAN;
CREATE FUNCTION namelike(NAME, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION namelt(NAME, NAME) RETURNS BOOLEAN;
CREATE FUNCTION namene(NAME, NAME) RETURNS BOOLEAN;
CREATE FUNCTION namenlike(NAME, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION nameout(NAME) RETURNS CSTRING;
CREATE FUNCTION namerecv(INTERNAL) RETURNS NAME;
CREATE FUNCTION nameregexeq(NAME, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION nameregexne(NAME, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION namesend(NAME) RETURNS BYTEA;
CREATE FUNCTION neqjoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION neqsel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION netmask(INET) RETURNS INET;
CREATE FUNCTION network(INET) RETURNS CIDR;
CREATE FUNCTION network_cmp(INET, INET) RETURNS INTEGER;
CREATE FUNCTION network_eq(INET, INET) RETURNS BOOLEAN;
CREATE FUNCTION network_ge(INET, INET) RETURNS BOOLEAN;
CREATE FUNCTION network_gt(INET, INET) RETURNS BOOLEAN;
CREATE FUNCTION network_larger(INET, INET) RETURNS INET;
CREATE FUNCTION network_le(INET, INET) RETURNS BOOLEAN;
CREATE FUNCTION network_lt(INET, INET) RETURNS BOOLEAN;
CREATE FUNCTION network_ne(INET, INET) RETURNS BOOLEAN;
CREATE FUNCTION network_overlap(INET, INET) RETURNS BOOLEAN;
CREATE FUNCTION network_smaller(INET, INET) RETURNS INET;
CREATE FUNCTION network_sub(INET, INET) RETURNS BOOLEAN;
CREATE FUNCTION network_subeq(INET, INET) RETURNS BOOLEAN;
CREATE FUNCTION network_sup(INET, INET) RETURNS BOOLEAN;
CREATE FUNCTION network_supeq(INET, INET) RETURNS BOOLEAN;
CREATE FUNCTION networkjoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION networksel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION nextval(REGCLASS) RETURNS BIGINT;
CREATE FUNCTION nlikejoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION nlikesel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION notlike(BYTEA, BYTEA) RETURNS BOOLEAN;
CREATE FUNCTION notlike(NAME, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION notlike(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION now() RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION npoints(PATH) RETURNS INTEGER;
CREATE FUNCTION npoints(POLYGON) RETURNS INTEGER;
CREATE FUNCTION nth_value(ANYELEMENT, INTEGER) RETURNS ANYELEMENT;
CREATE FUNCTION ntile(INTEGER) RETURNS INTEGER;
CREATE FUNCTION numeric(BIGINT) RETURNS NUMERIC;
CREATE FUNCTION numeric(DOUBLE PRECISION) RETURNS NUMERIC;
CREATE FUNCTION numeric(INTEGER) RETURNS NUMERIC;
CREATE FUNCTION numeric(MONEY) RETURNS NUMERIC;
CREATE FUNCTION numeric(NUMERIC, INTEGER) RETURNS NUMERIC;
CREATE FUNCTION numeric(REAL) RETURNS NUMERIC;
CREATE FUNCTION numeric(SMALLINT) RETURNS NUMERIC;
CREATE FUNCTION numeric_abs(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_accum(INTERNAL, NUMERIC) RETURNS INTERNAL;
CREATE FUNCTION numeric_accum_inv(INTERNAL, NUMERIC) RETURNS INTERNAL;
CREATE FUNCTION numeric_add(NUMERIC, NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_avg(INTERNAL) RETURNS NUMERIC;
CREATE FUNCTION numeric_avg_accum(INTERNAL, NUMERIC) RETURNS INTERNAL;
CREATE FUNCTION numeric_cmp(NUMERIC, NUMERIC) RETURNS INTEGER;
CREATE FUNCTION numeric_div(NUMERIC, NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_div_trunc(NUMERIC, NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_eq(NUMERIC, NUMERIC) RETURNS BOOLEAN;
CREATE FUNCTION numeric_exp(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_fac(BIGINT) RETURNS NUMERIC;
CREATE FUNCTION numeric_ge(NUMERIC, NUMERIC) RETURNS BOOLEAN;
CREATE FUNCTION numeric_gt(NUMERIC, NUMERIC) RETURNS BOOLEAN;
CREATE FUNCTION numeric_in(CSTRING, OID, INTEGER) RETURNS NUMERIC;
CREATE FUNCTION numeric_inc(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_larger(NUMERIC, NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_le(NUMERIC, NUMERIC) RETURNS BOOLEAN;
CREATE FUNCTION numeric_ln(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_log(NUMERIC, NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_lt(NUMERIC, NUMERIC) RETURNS BOOLEAN;
CREATE FUNCTION numeric_mod(NUMERIC, NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_mul(NUMERIC, NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_ne(NUMERIC, NUMERIC) RETURNS BOOLEAN;
CREATE FUNCTION numeric_out(NUMERIC) RETURNS CSTRING;
CREATE FUNCTION numeric_poly_avg(INTERNAL) RETURNS NUMERIC;
CREATE FUNCTION numeric_poly_stddev_pop(INTERNAL) RETURNS NUMERIC;
CREATE FUNCTION numeric_poly_stddev_samp(INTERNAL) RETURNS NUMERIC;
CREATE FUNCTION numeric_poly_sum(INTERNAL) RETURNS NUMERIC;
CREATE FUNCTION numeric_poly_var_pop(INTERNAL) RETURNS NUMERIC;
CREATE FUNCTION numeric_poly_var_samp(INTERNAL) RETURNS NUMERIC;
CREATE FUNCTION numeric_power(NUMERIC, NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_recv(INTERNAL, OID, INTEGER) RETURNS NUMERIC;
CREATE FUNCTION numeric_send(NUMERIC) RETURNS BYTEA;
CREATE FUNCTION numeric_smaller(NUMERIC, NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_sortsupport(INTERNAL) RETURNS VOID;
CREATE FUNCTION numeric_sqrt(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_stddev_pop(INTERNAL) RETURNS NUMERIC;
CREATE FUNCTION numeric_stddev_samp(INTERNAL) RETURNS NUMERIC;
CREATE FUNCTION numeric_sub(NUMERIC, NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_sum(INTERNAL) RETURNS NUMERIC;
CREATE FUNCTION numeric_transform(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION numeric_uminus(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_uplus(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION numeric_var_pop(INTERNAL) RETURNS NUMERIC;
CREATE FUNCTION numeric_var_samp(INTERNAL) RETURNS NUMERIC;
CREATE FUNCTION numerictypmodin(CSTRING[]) RETURNS INTEGER;
CREATE FUNCTION numerictypmodout(INTEGER) RETURNS CSTRING;
CREATE FUNCTION numnode(TSQUERY) RETURNS INTEGER;
CREATE FUNCTION numrange(NUMERIC, NUMERIC) RETURNS NUMRANGE;
CREATE FUNCTION numrange(NUMERIC, NUMERIC, TEXT) RETURNS NUMRANGE;
CREATE FUNCTION numrange_subdiff(NUMERIC, NUMERIC) RETURNS DOUBLE PRECISION;
CREATE FUNCTION obj_description(OID) RETURNS TEXT;
CREATE FUNCTION obj_description(OID, NAME) RETURNS TEXT;
CREATE FUNCTION octet_length(BIT) RETURNS INTEGER;
CREATE FUNCTION octet_length(BYTEA) RETURNS INTEGER;
CREATE FUNCTION octet_length(CHAR) RETURNS INTEGER;
CREATE FUNCTION octet_length(TEXT) RETURNS INTEGER;
CREATE FUNCTION oid(BIGINT) RETURNS OID;
CREATE FUNCTION oideq(OID, OID) RETURNS BOOLEAN;
CREATE FUNCTION oidge(OID, OID) RETURNS BOOLEAN;
CREATE FUNCTION oidgt(OID, OID) RETURNS BOOLEAN;
CREATE FUNCTION oidin(CSTRING) RETURNS OID;
CREATE FUNCTION oidlarger(OID, OID) RETURNS OID;
CREATE FUNCTION oidle(OID, OID) RETURNS BOOLEAN;
CREATE FUNCTION oidlt(OID, OID) RETURNS BOOLEAN;
CREATE FUNCTION oidne(OID, OID) RETURNS BOOLEAN;
CREATE FUNCTION oidout(OID) RETURNS CSTRING;
CREATE FUNCTION oidrecv(INTERNAL) RETURNS OID;
CREATE FUNCTION oidsend(OID) RETURNS BYTEA;
CREATE FUNCTION oidsmaller(OID, OID) RETURNS OID;
CREATE FUNCTION oidvectoreq(OIDVECTOR, OIDVECTOR) RETURNS BOOLEAN;
CREATE FUNCTION oidvectorge(OIDVECTOR, OIDVECTOR) RETURNS BOOLEAN;
CREATE FUNCTION oidvectorgt(OIDVECTOR, OIDVECTOR) RETURNS BOOLEAN;
CREATE FUNCTION oidvectorin(CSTRING) RETURNS OIDVECTOR;
CREATE FUNCTION oidvectorle(OIDVECTOR, OIDVECTOR) RETURNS BOOLEAN;
CREATE FUNCTION oidvectorlt(OIDVECTOR, OIDVECTOR) RETURNS BOOLEAN;
CREATE FUNCTION oidvectorne(OIDVECTOR, OIDVECTOR) RETURNS BOOLEAN;
CREATE FUNCTION oidvectorout(OIDVECTOR) RETURNS CSTRING;
CREATE FUNCTION oidvectorrecv(INTERNAL) RETURNS OIDVECTOR;
CREATE FUNCTION oidvectorsend(OIDVECTOR) RETURNS BYTEA;
CREATE FUNCTION oidvectortypes(OIDVECTOR) RETURNS TEXT;
CREATE FUNCTION on_pb(POINT, BOX) RETURNS BOOLEAN;
CREATE FUNCTION on_pl(POINT, LINE) RETURNS BOOLEAN;
CREATE FUNCTION on_ppath(POINT, PATH) RETURNS BOOLEAN;
CREATE FUNCTION on_ps(POINT, LSEG) RETURNS BOOLEAN;
CREATE FUNCTION on_sb(LSEG, BOX) RETURNS BOOLEAN;
CREATE FUNCTION on_sl(LSEG, LINE) RETURNS BOOLEAN;
CREATE FUNCTION opaque_in(CSTRING) RETURNS OPAQUE;
CREATE FUNCTION opaque_out(OPAQUE) RETURNS CSTRING;
CREATE FUNCTION ordered_set_transition(INTERNAL, "any") RETURNS INTERNAL;
CREATE FUNCTION ordered_set_transition_multi(INTERNAL, "any") RETURNS INTERNAL;
CREATE FUNCTION "overlaps"(TIME WITH TIME ZONE, TIME WITH TIME ZONE, TIME WITH TIME ZONE, TIME WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION "overlaps"(TIME, INTERVAL, TIME, INTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION "overlaps"(TIME, INTERVAL, TIME, TIME) RETURNS BOOLEAN;
CREATE FUNCTION "overlaps"(TIME, TIME, TIME, INTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION "overlaps"(TIME, TIME, TIME, TIME) RETURNS BOOLEAN;
CREATE FUNCTION "overlaps"(TIMESTAMP WITH TIME ZONE, INTERVAL, TIMESTAMP WITH TIME ZONE, INTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION "overlaps"(TIMESTAMP WITH TIME ZONE, INTERVAL, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION "overlaps"(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE, INTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION "overlaps"(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION "overlaps"(TIMESTAMP, INTERVAL, TIMESTAMP, INTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION "overlaps"(TIMESTAMP, INTERVAL, TIMESTAMP, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION "overlaps"(TIMESTAMP, TIMESTAMP, TIMESTAMP, INTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION "overlaps"(TIMESTAMP, TIMESTAMP, TIMESTAMP, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION overlay(BIT, BIT, INTEGER) RETURNS BIT;
CREATE FUNCTION overlay(BIT, BIT, INTEGER, INTEGER) RETURNS BIT;
CREATE FUNCTION overlay(BYTEA, BYTEA, INTEGER) RETURNS BYTEA;
CREATE FUNCTION overlay(BYTEA, BYTEA, INTEGER, INTEGER) RETURNS BYTEA;
CREATE FUNCTION overlay(TEXT, TEXT, INTEGER) RETURNS TEXT;
CREATE FUNCTION overlay(TEXT, TEXT, INTEGER, INTEGER) RETURNS TEXT;
CREATE FUNCTION path(POLYGON) RETURNS PATH;
CREATE FUNCTION path_add(PATH, PATH) RETURNS PATH;
CREATE FUNCTION path_add_pt(PATH, POINT) RETURNS PATH;
CREATE FUNCTION path_center(PATH) RETURNS POINT;
CREATE FUNCTION path_contain_pt(PATH, POINT) RETURNS BOOLEAN;
CREATE FUNCTION path_distance(PATH, PATH) RETURNS DOUBLE PRECISION;
CREATE FUNCTION path_div_pt(PATH, POINT) RETURNS PATH;
CREATE FUNCTION path_in(CSTRING) RETURNS PATH;
CREATE FUNCTION path_inter(PATH, PATH) RETURNS BOOLEAN;
CREATE FUNCTION path_length(PATH) RETURNS DOUBLE PRECISION;
CREATE FUNCTION path_mul_pt(PATH, POINT) RETURNS PATH;
CREATE FUNCTION path_n_eq(PATH, PATH) RETURNS BOOLEAN;
CREATE FUNCTION path_n_ge(PATH, PATH) RETURNS BOOLEAN;
CREATE FUNCTION path_n_gt(PATH, PATH) RETURNS BOOLEAN;
CREATE FUNCTION path_n_le(PATH, PATH) RETURNS BOOLEAN;
CREATE FUNCTION path_n_lt(PATH, PATH) RETURNS BOOLEAN;
CREATE FUNCTION path_npoints(PATH) RETURNS INTEGER;
CREATE FUNCTION path_out(PATH) RETURNS CSTRING;
CREATE FUNCTION path_recv(INTERNAL) RETURNS PATH;
CREATE FUNCTION path_send(PATH) RETURNS BYTEA;
CREATE FUNCTION path_sub_pt(PATH, POINT) RETURNS PATH;
CREATE FUNCTION pclose(PATH) RETURNS PATH;
CREATE FUNCTION percent_rank("any") RETURNS DOUBLE PRECISION;
CREATE FUNCTION percent_rank() RETURNS DOUBLE PRECISION;
CREATE FUNCTION percent_rank_final(INTERNAL, "any") RETURNS DOUBLE PRECISION;
CREATE FUNCTION percentile_cont(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION percentile_cont(DOUBLE PRECISION, INTERVAL) RETURNS INTERVAL;
CREATE FUNCTION percentile_cont(DOUBLE PRECISION[], DOUBLE PRECISION) RETURNS DOUBLE PRECISION[];
CREATE FUNCTION percentile_cont(DOUBLE PRECISION[], INTERVAL) RETURNS INTERVAL[];
CREATE FUNCTION percentile_cont_float8_final(INTERNAL, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION percentile_cont_float8_multi_final(INTERNAL, DOUBLE PRECISION[]) RETURNS DOUBLE PRECISION[];
CREATE FUNCTION percentile_cont_interval_final(INTERNAL, DOUBLE PRECISION) RETURNS INTERVAL;
CREATE FUNCTION percentile_cont_interval_multi_final(INTERNAL, DOUBLE PRECISION[]) RETURNS INTERVAL[];
CREATE FUNCTION percentile_disc(DOUBLE PRECISION, ANYELEMENT) RETURNS ANYELEMENT;
CREATE FUNCTION percentile_disc(DOUBLE PRECISION[], ANYELEMENT) RETURNS ANYARRAY;
CREATE FUNCTION percentile_disc_final(INTERNAL, DOUBLE PRECISION, ANYELEMENT) RETURNS ANYELEMENT;
CREATE FUNCTION percentile_disc_multi_final(INTERNAL, DOUBLE PRECISION[], ANYELEMENT) RETURNS ANYARRAY;
CREATE FUNCTION pg_advisory_lock(BIGINT) RETURNS VOID;
CREATE FUNCTION pg_advisory_lock(INTEGER, INTEGER) RETURNS VOID;
CREATE FUNCTION pg_advisory_lock_shared(BIGINT) RETURNS VOID;
CREATE FUNCTION pg_advisory_lock_shared(INTEGER, INTEGER) RETURNS VOID;
CREATE FUNCTION pg_advisory_unlock(BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION pg_advisory_unlock(INTEGER, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION pg_advisory_unlock_all() RETURNS VOID;
CREATE FUNCTION pg_advisory_unlock_shared(BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION pg_advisory_unlock_shared(INTEGER, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION pg_advisory_xact_lock(BIGINT) RETURNS VOID;
CREATE FUNCTION pg_advisory_xact_lock(INTEGER, INTEGER) RETURNS VOID;
CREATE FUNCTION pg_advisory_xact_lock_shared(BIGINT) RETURNS VOID;
CREATE FUNCTION pg_advisory_xact_lock_shared(INTEGER, INTEGER) RETURNS VOID;
CREATE FUNCTION pg_available_extension_versions(name OUT NAME, version OUT TEXT, superuser OUT BOOLEAN, relocatable OUT BOOLEAN, schema OUT NAME, requires OUT NAME[], comment OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION pg_available_extensions(name OUT NAME, default_version OUT TEXT, comment OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION pg_backend_pid() RETURNS INTEGER;
CREATE FUNCTION pg_backup_start_time() RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION pg_cancel_backend(INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION pg_char_to_encoding(NAME) RETURNS INTEGER;
CREATE FUNCTION pg_client_encoding() RETURNS NAME;
CREATE FUNCTION pg_collation_for("any") RETURNS TEXT;
CREATE FUNCTION pg_collation_is_visible(OID) RETURNS BOOLEAN;
CREATE FUNCTION pg_column_is_updatable(REGCLASS, SMALLINT, BOOLEAN) RETURNS BOOLEAN;
CREATE FUNCTION pg_column_size("any") RETURNS INTEGER;
CREATE FUNCTION pg_conf_load_time() RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION pg_conversion_is_visible(OID) RETURNS BOOLEAN;
CREATE FUNCTION pg_create_logical_replication_slot(slot_name NAME, plugin NAME, slot_name OUT TEXT, xlog_position OUT PG_LSN) RETURNS RECORD;
CREATE FUNCTION pg_create_physical_replication_slot(slot_name NAME, slot_name OUT NAME, xlog_position OUT PG_LSN) RETURNS RECORD;
CREATE FUNCTION pg_create_restore_point(TEXT) RETURNS PG_LSN;
CREATE FUNCTION pg_current_xlog_insert_location() RETURNS PG_LSN;
CREATE FUNCTION pg_current_xlog_location() RETURNS PG_LSN;
CREATE FUNCTION pg_cursor(name OUT TEXT, statement OUT TEXT, is_holdable OUT BOOLEAN, is_binary OUT BOOLEAN, is_scrollable OUT BOOLEAN, creation_time OUT TIMESTAMP WITH TIME ZONE) RETURNS SETOF RECORD;
CREATE FUNCTION pg_database_size(NAME) RETURNS BIGINT;
CREATE FUNCTION pg_database_size(OID) RETURNS BIGINT;
CREATE FUNCTION pg_ddl_command_in(CSTRING) RETURNS PG_DDL_COMMAND;
CREATE FUNCTION pg_ddl_command_out(PG_DDL_COMMAND) RETURNS CSTRING;
CREATE FUNCTION pg_ddl_command_recv(INTERNAL) RETURNS PG_DDL_COMMAND;
CREATE FUNCTION pg_ddl_command_send(PG_DDL_COMMAND) RETURNS BYTEA;
CREATE FUNCTION pg_describe_object(OID, OID, INTEGER) RETURNS TEXT;
CREATE FUNCTION pg_drop_replication_slot(NAME) RETURNS VOID;
CREATE FUNCTION pg_encoding_max_length(INTEGER) RETURNS INTEGER;
CREATE FUNCTION pg_encoding_to_char(INTEGER) RETURNS NAME;
CREATE FUNCTION pg_event_trigger_ddl_commands(classid OUT OID, objid OUT OID, objsubid OUT INTEGER, command_tag OUT TEXT, object_type OUT TEXT, schema_name OUT TEXT, object_identity OUT TEXT, in_extension OUT BOOLEAN, command OUT PG_DDL_COMMAND) RETURNS SETOF RECORD;
CREATE FUNCTION pg_event_trigger_dropped_objects(classid OUT OID, objid OUT OID, objsubid OUT INTEGER, original OUT BOOLEAN, normal OUT BOOLEAN, is_temporary OUT BOOLEAN, object_type OUT TEXT, schema_name OUT TEXT, object_name OUT TEXT, object_identity OUT TEXT, address_names OUT TEXT[], address_args OUT TEXT[]) RETURNS SETOF RECORD;
CREATE FUNCTION pg_event_trigger_table_rewrite_oid(oid OUT OID) RETURNS OID;
CREATE FUNCTION pg_event_trigger_table_rewrite_reason() RETURNS INTEGER;
CREATE FUNCTION pg_export_snapshot() RETURNS TEXT;
CREATE FUNCTION pg_extension_config_dump(REGCLASS, TEXT) RETURNS VOID;
CREATE FUNCTION pg_extension_update_paths(name NAME, source OUT TEXT, target OUT TEXT, path OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION pg_filenode_relation(OID, OID) RETURNS REGCLASS;
CREATE FUNCTION pg_function_is_visible(OID) RETURNS BOOLEAN;
CREATE FUNCTION pg_get_constraintdef(OID) RETURNS TEXT;
CREATE FUNCTION pg_get_constraintdef(OID, BOOLEAN) RETURNS TEXT;
CREATE FUNCTION pg_get_expr(PG_NODE_TREE, OID) RETURNS TEXT;
CREATE FUNCTION pg_get_expr(PG_NODE_TREE, OID, BOOLEAN) RETURNS TEXT;
CREATE FUNCTION pg_get_function_arg_default(OID, INTEGER) RETURNS TEXT;
CREATE FUNCTION pg_get_function_arguments(OID) RETURNS TEXT;
CREATE FUNCTION pg_get_function_identity_arguments(OID) RETURNS TEXT;
CREATE FUNCTION pg_get_function_result(OID) RETURNS TEXT;
CREATE FUNCTION pg_get_functiondef(OID) RETURNS TEXT;
CREATE FUNCTION pg_get_indexdef(OID) RETURNS TEXT;
CREATE FUNCTION pg_get_indexdef(OID, INTEGER, BOOLEAN) RETURNS TEXT;
CREATE FUNCTION pg_get_keywords(word OUT TEXT, catcode OUT "char", catdesc OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION pg_get_multixact_members(multixid XID, xid OUT XID, mode OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION pg_get_object_address(type TEXT, name TEXT[], args TEXT[], classid OUT OID, objid OUT OID, subobjid OUT INTEGER) RETURNS RECORD;
CREATE FUNCTION pg_get_replication_slots(slot_name OUT NAME, plugin OUT NAME, slot_type OUT TEXT, datoid OUT OID, active OUT BOOLEAN, active_pid OUT INTEGER, xmin OUT XID, catalog_xmin OUT XID, restart_lsn OUT PG_LSN) RETURNS SETOF RECORD;
CREATE FUNCTION pg_get_ruledef(OID) RETURNS TEXT;
CREATE FUNCTION pg_get_ruledef(OID, BOOLEAN) RETURNS TEXT;
CREATE FUNCTION pg_get_serial_sequence(TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION pg_get_triggerdef(OID) RETURNS TEXT;
CREATE FUNCTION pg_get_triggerdef(OID, BOOLEAN) RETURNS TEXT;
CREATE FUNCTION pg_get_userbyid(OID) RETURNS NAME;
CREATE FUNCTION pg_get_viewdef(OID) RETURNS TEXT;
CREATE FUNCTION pg_get_viewdef(OID, BOOLEAN) RETURNS TEXT;
CREATE FUNCTION pg_get_viewdef(OID, INTEGER) RETURNS TEXT;
CREATE FUNCTION pg_get_viewdef(TEXT) RETURNS TEXT;
CREATE FUNCTION pg_get_viewdef(TEXT, BOOLEAN) RETURNS TEXT;
CREATE FUNCTION pg_has_role(NAME, NAME, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION pg_has_role(NAME, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION pg_has_role(NAME, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION pg_has_role(OID, NAME, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION pg_has_role(OID, OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION pg_has_role(OID, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION pg_identify_object(classid OID, objid OID, subobjid INTEGER, type OUT TEXT, schema OUT TEXT, name OUT TEXT, identity OUT TEXT) RETURNS RECORD;
CREATE FUNCTION pg_identify_object_as_address(classid OID, objid OID, subobjid INTEGER, type OUT TEXT, object_names OUT TEXT[], object_args OUT TEXT[]) RETURNS RECORD;
CREATE FUNCTION pg_indexes_size(REGCLASS) RETURNS BIGINT;
CREATE FUNCTION pg_is_in_backup() RETURNS BOOLEAN;
CREATE FUNCTION pg_is_in_recovery() RETURNS BOOLEAN;
CREATE FUNCTION pg_is_other_temp_schema(OID) RETURNS BOOLEAN;
CREATE FUNCTION pg_is_xlog_replay_paused() RETURNS BOOLEAN;
CREATE FUNCTION pg_last_committed_xact(xid OUT XID, timestamp OUT TIMESTAMP WITH TIME ZONE) RETURNS RECORD;
CREATE FUNCTION pg_last_xact_replay_timestamp() RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION pg_last_xlog_receive_location() RETURNS PG_LSN;
CREATE FUNCTION pg_last_xlog_replay_location() RETURNS PG_LSN;
CREATE FUNCTION pg_listening_channels() RETURNS SETOF TEXT;
CREATE FUNCTION pg_lock_status(locktype OUT TEXT, database OUT OID, relation OUT OID, page OUT INTEGER, tuple OUT SMALLINT, virtualxid OUT TEXT, transactionid OUT XID, classid OUT OID, objid OUT OID, objsubid OUT SMALLINT, virtualtransaction OUT TEXT, pid OUT INTEGER, mode OUT TEXT, granted OUT BOOLEAN, fastpath OUT BOOLEAN) RETURNS SETOF RECORD;
CREATE FUNCTION pg_logical_slot_get_binary_changes(slot_name NAME, upto_lsn PG_LSN, upto_nchanges INTEGER, options TEXT[], location OUT PG_LSN, xid OUT XID, data OUT BYTEA) RETURNS SETOF RECORD;
CREATE FUNCTION pg_logical_slot_get_changes(slot_name NAME, upto_lsn PG_LSN, upto_nchanges INTEGER, options TEXT[], location OUT PG_LSN, xid OUT XID, data OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION pg_logical_slot_peek_binary_changes(slot_name NAME, upto_lsn PG_LSN, upto_nchanges INTEGER, options TEXT[], location OUT PG_LSN, xid OUT XID, data OUT BYTEA) RETURNS SETOF RECORD;
CREATE FUNCTION pg_logical_slot_peek_changes(slot_name NAME, upto_lsn PG_LSN, upto_nchanges INTEGER, options TEXT[], location OUT PG_LSN, xid OUT XID, data OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION pg_ls_dir(TEXT) RETURNS SETOF TEXT;
CREATE FUNCTION pg_ls_dir(TEXT, BOOLEAN, BOOLEAN) RETURNS SETOF TEXT;
CREATE FUNCTION pg_lsn_cmp(PG_LSN, PG_LSN) RETURNS INTEGER;
CREATE FUNCTION pg_lsn_eq(PG_LSN, PG_LSN) RETURNS BOOLEAN;
CREATE FUNCTION pg_lsn_ge(PG_LSN, PG_LSN) RETURNS BOOLEAN;
CREATE FUNCTION pg_lsn_gt(PG_LSN, PG_LSN) RETURNS BOOLEAN;
CREATE FUNCTION pg_lsn_hash(PG_LSN) RETURNS INTEGER;
CREATE FUNCTION pg_lsn_in(CSTRING) RETURNS PG_LSN;
CREATE FUNCTION pg_lsn_le(PG_LSN, PG_LSN) RETURNS BOOLEAN;
CREATE FUNCTION pg_lsn_lt(PG_LSN, PG_LSN) RETURNS BOOLEAN;
CREATE FUNCTION pg_lsn_mi(PG_LSN, PG_LSN) RETURNS NUMERIC;
CREATE FUNCTION pg_lsn_ne(PG_LSN, PG_LSN) RETURNS BOOLEAN;
CREATE FUNCTION pg_lsn_out(PG_LSN) RETURNS CSTRING;
CREATE FUNCTION pg_lsn_recv(INTERNAL) RETURNS PG_LSN;
CREATE FUNCTION pg_lsn_send(PG_LSN) RETURNS BYTEA;
CREATE FUNCTION pg_my_temp_schema() RETURNS OID;
CREATE FUNCTION pg_node_tree_in(CSTRING) RETURNS PG_NODE_TREE;
CREATE FUNCTION pg_node_tree_out(PG_NODE_TREE) RETURNS CSTRING;
CREATE FUNCTION pg_node_tree_recv(INTERNAL) RETURNS PG_NODE_TREE;
CREATE FUNCTION pg_node_tree_send(PG_NODE_TREE) RETURNS BYTEA;
CREATE FUNCTION pg_notify(TEXT, TEXT) RETURNS VOID;
CREATE FUNCTION pg_opclass_is_visible(OID) RETURNS BOOLEAN;
CREATE FUNCTION pg_operator_is_visible(OID) RETURNS BOOLEAN;
CREATE FUNCTION pg_opfamily_is_visible(OID) RETURNS BOOLEAN;
CREATE FUNCTION pg_options_to_table(options_array TEXT[], option_name OUT TEXT, option_value OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION pg_postmaster_start_time() RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION pg_prepared_statement(name OUT TEXT, statement OUT TEXT, prepare_time OUT TIMESTAMP WITH TIME ZONE, parameter_types OUT REGTYPE[], from_sql OUT BOOLEAN) RETURNS SETOF RECORD;
CREATE FUNCTION pg_prepared_xact(transaction OUT XID, gid OUT TEXT, prepared OUT TIMESTAMP WITH TIME ZONE, ownerid OUT OID, dbid OUT OID) RETURNS SETOF RECORD;
CREATE FUNCTION pg_read_binary_file(TEXT) RETURNS BYTEA;
CREATE FUNCTION pg_read_binary_file(TEXT, BIGINT, BIGINT) RETURNS BYTEA;
CREATE FUNCTION pg_read_binary_file(TEXT, BIGINT, BIGINT, BOOLEAN) RETURNS BYTEA;
CREATE FUNCTION pg_read_file(TEXT) RETURNS TEXT;
CREATE FUNCTION pg_read_file(TEXT, BIGINT, BIGINT) RETURNS TEXT;
CREATE FUNCTION pg_read_file(TEXT, BIGINT, BIGINT, BOOLEAN) RETURNS TEXT;
CREATE FUNCTION pg_relation_filenode(REGCLASS) RETURNS OID;
CREATE FUNCTION pg_relation_filepath(REGCLASS) RETURNS TEXT;
CREATE FUNCTION pg_relation_is_updatable(REGCLASS, BOOLEAN) RETURNS INTEGER;
CREATE FUNCTION pg_relation_size(REGCLASS) RETURNS BIGINT;
CREATE FUNCTION pg_relation_size(REGCLASS, TEXT) RETURNS BIGINT;
CREATE FUNCTION pg_reload_conf() RETURNS BOOLEAN;
CREATE FUNCTION pg_replication_origin_advance(TEXT, PG_LSN) RETURNS VOID;
CREATE FUNCTION pg_replication_origin_create(TEXT) RETURNS OID;
CREATE FUNCTION pg_replication_origin_drop(TEXT) RETURNS VOID;
CREATE FUNCTION pg_replication_origin_oid(TEXT) RETURNS OID;
CREATE FUNCTION pg_replication_origin_progress(TEXT, BOOLEAN) RETURNS PG_LSN;
CREATE FUNCTION pg_replication_origin_session_is_setup() RETURNS BOOLEAN;
CREATE FUNCTION pg_replication_origin_session_progress(BOOLEAN) RETURNS PG_LSN;
CREATE FUNCTION pg_replication_origin_session_reset() RETURNS VOID;
CREATE FUNCTION pg_replication_origin_session_setup(TEXT) RETURNS VOID;
CREATE FUNCTION pg_replication_origin_xact_reset(PG_LSN, TIMESTAMP WITH TIME ZONE) RETURNS VOID;
CREATE FUNCTION pg_replication_origin_xact_setup(PG_LSN, TIMESTAMP WITH TIME ZONE) RETURNS VOID;
CREATE FUNCTION pg_rotate_logfile() RETURNS BOOLEAN;
CREATE FUNCTION pg_sequence_parameters(sequence_oid OID, start_value OUT BIGINT, minimum_value OUT BIGINT, maximum_value OUT BIGINT, increment OUT BIGINT, cycle_option OUT BOOLEAN) RETURNS RECORD;
CREATE FUNCTION pg_show_all_file_settings(sourcefile OUT TEXT, sourceline OUT INTEGER, seqno OUT INTEGER, name OUT TEXT, setting OUT TEXT, applied OUT BOOLEAN, error OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION pg_show_all_settings(name OUT TEXT, setting OUT TEXT, unit OUT TEXT, category OUT TEXT, short_desc OUT TEXT, extra_desc OUT TEXT, context OUT TEXT, vartype OUT TEXT, source OUT TEXT, min_val OUT TEXT, max_val OUT TEXT, enumvals OUT TEXT[], boot_val OUT TEXT, reset_val OUT TEXT, sourcefile OUT TEXT, sourceline OUT INTEGER, pending_restart OUT BOOLEAN) RETURNS SETOF RECORD;
CREATE FUNCTION pg_show_replication_origin_status(local_id OUT OID, external_id OUT TEXT, remote_lsn OUT PG_LSN, local_lsn OUT PG_LSN) RETURNS SETOF RECORD;
CREATE FUNCTION pg_size_pretty(BIGINT) RETURNS TEXT;
CREATE FUNCTION pg_size_pretty(NUMERIC) RETURNS TEXT;
CREATE FUNCTION pg_sleep(DOUBLE PRECISION) RETURNS VOID;
CREATE FUNCTION pg_sleep_for(INTERVAL) RETURNS VOID;
CREATE FUNCTION pg_sleep_until(TIMESTAMP WITH TIME ZONE) RETURNS VOID;
CREATE FUNCTION pg_start_backup(label TEXT, fast BOOLEAN) RETURNS PG_LSN;
CREATE FUNCTION pg_stat_clear_snapshot() RETURNS VOID;
CREATE FUNCTION pg_stat_file(filename TEXT, size OUT BIGINT, access OUT TIMESTAMP WITH TIME ZONE, modification OUT TIMESTAMP WITH TIME ZONE, change OUT TIMESTAMP WITH TIME ZONE, creation OUT TIMESTAMP WITH TIME ZONE, isdir OUT BOOLEAN) RETURNS RECORD;
CREATE FUNCTION pg_stat_file(filename TEXT, missing_ok BOOLEAN, size OUT BIGINT, access OUT TIMESTAMP WITH TIME ZONE, modification OUT TIMESTAMP WITH TIME ZONE, change OUT TIMESTAMP WITH TIME ZONE, creation OUT TIMESTAMP WITH TIME ZONE, isdir OUT BOOLEAN) RETURNS RECORD;
CREATE FUNCTION pg_stat_get_activity(pid INTEGER, datid OUT OID, pid OUT INTEGER, usesysid OUT OID, application_name OUT TEXT, state OUT TEXT, query OUT TEXT, waiting OUT BOOLEAN, xact_start OUT TIMESTAMP WITH TIME ZONE, query_start OUT TIMESTAMP WITH TIME ZONE, backend_start OUT TIMESTAMP WITH TIME ZONE, state_change OUT TIMESTAMP WITH TIME ZONE, client_addr OUT INET, client_hostname OUT TEXT, client_port OUT INTEGER, backend_xid OUT XID, backend_xmin OUT XID, ssl OUT BOOLEAN, sslversion OUT TEXT, sslcipher OUT TEXT, sslbits OUT INTEGER, sslcompression OUT BOOLEAN, sslclientdn OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION pg_stat_get_analyze_count(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_archiver(archived_count OUT BIGINT, last_archived_wal OUT TEXT, last_archived_time OUT TIMESTAMP WITH TIME ZONE, failed_count OUT BIGINT, last_failed_wal OUT TEXT, last_failed_time OUT TIMESTAMP WITH TIME ZONE, stats_reset OUT TIMESTAMP WITH TIME ZONE) RETURNS RECORD;
CREATE FUNCTION pg_stat_get_autoanalyze_count(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_autovacuum_count(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_backend_activity(INTEGER) RETURNS TEXT;
CREATE FUNCTION pg_stat_get_backend_activity_start(INTEGER) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION pg_stat_get_backend_client_addr(INTEGER) RETURNS INET;
CREATE FUNCTION pg_stat_get_backend_client_port(INTEGER) RETURNS INTEGER;
CREATE FUNCTION pg_stat_get_backend_dbid(INTEGER) RETURNS OID;
CREATE FUNCTION pg_stat_get_backend_idset() RETURNS SETOF INTEGER;
CREATE FUNCTION pg_stat_get_backend_pid(INTEGER) RETURNS INTEGER;
CREATE FUNCTION pg_stat_get_backend_start(INTEGER) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION pg_stat_get_backend_userid(INTEGER) RETURNS OID;
CREATE FUNCTION pg_stat_get_backend_waiting(INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION pg_stat_get_backend_xact_start(INTEGER) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION pg_stat_get_bgwriter_buf_written_checkpoints() RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_bgwriter_buf_written_clean() RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_bgwriter_maxwritten_clean() RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_bgwriter_requested_checkpoints() RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_bgwriter_stat_reset_time() RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION pg_stat_get_bgwriter_timed_checkpoints() RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_blocks_fetched(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_blocks_hit(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_buf_alloc() RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_buf_fsync_backend() RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_buf_written_backend() RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_checkpoint_sync_time() RETURNS DOUBLE PRECISION;
CREATE FUNCTION pg_stat_get_checkpoint_write_time() RETURNS DOUBLE PRECISION;
CREATE FUNCTION pg_stat_get_db_blk_read_time(OID) RETURNS DOUBLE PRECISION;
CREATE FUNCTION pg_stat_get_db_blk_write_time(OID) RETURNS DOUBLE PRECISION;
CREATE FUNCTION pg_stat_get_db_blocks_fetched(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_blocks_hit(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_conflict_all(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_conflict_bufferpin(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_conflict_lock(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_conflict_snapshot(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_conflict_startup_deadlock(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_conflict_tablespace(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_deadlocks(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_numbackends(OID) RETURNS INTEGER;
CREATE FUNCTION pg_stat_get_db_stat_reset_time(OID) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION pg_stat_get_db_temp_bytes(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_temp_files(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_tuples_deleted(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_tuples_fetched(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_tuples_inserted(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_tuples_returned(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_tuples_updated(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_xact_commit(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_db_xact_rollback(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_dead_tuples(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_function_calls(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_function_self_time(OID) RETURNS DOUBLE PRECISION;
CREATE FUNCTION pg_stat_get_function_total_time(OID) RETURNS DOUBLE PRECISION;
CREATE FUNCTION pg_stat_get_last_analyze_time(OID) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION pg_stat_get_last_autoanalyze_time(OID) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION pg_stat_get_last_autovacuum_time(OID) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION pg_stat_get_last_vacuum_time(OID) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION pg_stat_get_live_tuples(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_mod_since_analyze(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_numscans(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_snapshot_timestamp() RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION pg_stat_get_tuples_deleted(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_tuples_fetched(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_tuples_hot_updated(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_tuples_inserted(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_tuples_returned(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_tuples_updated(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_vacuum_count(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_wal_senders(pid OUT INTEGER, state OUT TEXT, sent_location OUT PG_LSN, write_location OUT PG_LSN, flush_location OUT PG_LSN, replay_location OUT PG_LSN, sync_priority OUT INTEGER, sync_state OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION pg_stat_get_xact_blocks_fetched(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_xact_blocks_hit(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_xact_function_calls(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_xact_function_self_time(OID) RETURNS DOUBLE PRECISION;
CREATE FUNCTION pg_stat_get_xact_function_total_time(OID) RETURNS DOUBLE PRECISION;
CREATE FUNCTION pg_stat_get_xact_numscans(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_xact_tuples_deleted(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_xact_tuples_fetched(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_xact_tuples_hot_updated(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_xact_tuples_inserted(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_xact_tuples_returned(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_get_xact_tuples_updated(OID) RETURNS BIGINT;
CREATE FUNCTION pg_stat_reset() RETURNS VOID;
CREATE FUNCTION pg_stat_reset_shared(TEXT) RETURNS VOID;
CREATE FUNCTION pg_stat_reset_single_function_counters(OID) RETURNS VOID;
CREATE FUNCTION pg_stat_reset_single_table_counters(OID) RETURNS VOID;
CREATE FUNCTION pg_stop_backup() RETURNS PG_LSN;
CREATE FUNCTION pg_switch_xlog() RETURNS PG_LSN;
CREATE FUNCTION pg_table_is_visible(OID) RETURNS BOOLEAN;
CREATE FUNCTION pg_table_size(REGCLASS) RETURNS BIGINT;
CREATE FUNCTION pg_tablespace_databases(OID) RETURNS SETOF OID;
CREATE FUNCTION pg_tablespace_location(OID) RETURNS TEXT;
CREATE FUNCTION pg_tablespace_size(NAME) RETURNS BIGINT;
CREATE FUNCTION pg_tablespace_size(OID) RETURNS BIGINT;
CREATE FUNCTION pg_terminate_backend(INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION pg_timezone_abbrevs(abbrev OUT TEXT, utc_offset OUT INTERVAL, is_dst OUT BOOLEAN) RETURNS SETOF RECORD;
CREATE FUNCTION pg_timezone_names(name OUT TEXT, abbrev OUT TEXT, utc_offset OUT INTERVAL, is_dst OUT BOOLEAN) RETURNS SETOF RECORD;
CREATE FUNCTION pg_total_relation_size(REGCLASS) RETURNS BIGINT;
CREATE FUNCTION pg_trigger_depth() RETURNS INTEGER;
CREATE FUNCTION pg_try_advisory_lock(BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION pg_try_advisory_lock(INTEGER, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION pg_try_advisory_lock_shared(BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION pg_try_advisory_lock_shared(INTEGER, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION pg_try_advisory_xact_lock(BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION pg_try_advisory_xact_lock(INTEGER, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION pg_try_advisory_xact_lock_shared(BIGINT) RETURNS BOOLEAN;
CREATE FUNCTION pg_try_advisory_xact_lock_shared(INTEGER, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION pg_ts_config_is_visible(OID) RETURNS BOOLEAN;
CREATE FUNCTION pg_ts_dict_is_visible(OID) RETURNS BOOLEAN;
CREATE FUNCTION pg_ts_parser_is_visible(OID) RETURNS BOOLEAN;
CREATE FUNCTION pg_ts_template_is_visible(OID) RETURNS BOOLEAN;
CREATE FUNCTION pg_type_is_visible(OID) RETURNS BOOLEAN;
CREATE FUNCTION pg_typeof("any") RETURNS REGTYPE;
CREATE FUNCTION pg_xact_commit_timestamp(XID) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION pg_xlog_location_diff(PG_LSN, PG_LSN) RETURNS NUMERIC;
CREATE FUNCTION pg_xlog_replay_pause() RETURNS VOID;
CREATE FUNCTION pg_xlog_replay_resume() RETURNS VOID;
CREATE FUNCTION pg_xlogfile_name(PG_LSN) RETURNS TEXT;
CREATE FUNCTION pg_xlogfile_name_offset(wal_location PG_LSN, file_name OUT TEXT, file_offset OUT INTEGER) RETURNS RECORD;
CREATE FUNCTION pi() RETURNS DOUBLE PRECISION;
CREATE FUNCTION plainto_tsquery(REGCONFIG, TEXT) RETURNS TSQUERY;
CREATE FUNCTION plainto_tsquery(TEXT) RETURNS TSQUERY;
CREATE FUNCTION plpgsql_call_handler() RETURNS LANGUAGE_HANDLER;
CREATE FUNCTION plpgsql_inline_handler(INTERNAL) RETURNS VOID;
CREATE FUNCTION plpgsql_validator(OID) RETURNS VOID;
CREATE FUNCTION point(BOX) RETURNS POINT;
CREATE FUNCTION point(CIRCLE) RETURNS POINT;
CREATE FUNCTION point(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS POINT;
CREATE FUNCTION point(LSEG) RETURNS POINT;
CREATE FUNCTION point(PATH) RETURNS POINT;
CREATE FUNCTION point(POLYGON) RETURNS POINT;
CREATE FUNCTION point_above(POINT, POINT) RETURNS BOOLEAN;
CREATE FUNCTION point_add(POINT, POINT) RETURNS POINT;
CREATE FUNCTION point_below(POINT, POINT) RETURNS BOOLEAN;
CREATE FUNCTION point_distance(POINT, POINT) RETURNS DOUBLE PRECISION;
CREATE FUNCTION point_div(POINT, POINT) RETURNS POINT;
CREATE FUNCTION point_eq(POINT, POINT) RETURNS BOOLEAN;
CREATE FUNCTION point_horiz(POINT, POINT) RETURNS BOOLEAN;
CREATE FUNCTION point_in(CSTRING) RETURNS POINT;
CREATE FUNCTION point_left(POINT, POINT) RETURNS BOOLEAN;
CREATE FUNCTION point_mul(POINT, POINT) RETURNS POINT;
CREATE FUNCTION point_ne(POINT, POINT) RETURNS BOOLEAN;
CREATE FUNCTION point_out(POINT) RETURNS CSTRING;
CREATE FUNCTION point_recv(INTERNAL) RETURNS POINT;
CREATE FUNCTION point_right(POINT, POINT) RETURNS BOOLEAN;
CREATE FUNCTION point_send(POINT) RETURNS BYTEA;
CREATE FUNCTION point_sub(POINT, POINT) RETURNS POINT;
CREATE FUNCTION point_vert(POINT, POINT) RETURNS BOOLEAN;
CREATE FUNCTION poly_above(POLYGON, POLYGON) RETURNS BOOLEAN;
CREATE FUNCTION poly_below(POLYGON, POLYGON) RETURNS BOOLEAN;
CREATE FUNCTION poly_center(POLYGON) RETURNS POINT;
CREATE FUNCTION poly_contain(POLYGON, POLYGON) RETURNS BOOLEAN;
CREATE FUNCTION poly_contain_pt(POLYGON, POINT) RETURNS BOOLEAN;
CREATE FUNCTION poly_contained(POLYGON, POLYGON) RETURNS BOOLEAN;
CREATE FUNCTION poly_distance(POLYGON, POLYGON) RETURNS DOUBLE PRECISION;
CREATE FUNCTION poly_in(CSTRING) RETURNS POLYGON;
CREATE FUNCTION poly_left(POLYGON, POLYGON) RETURNS BOOLEAN;
CREATE FUNCTION poly_npoints(POLYGON) RETURNS INTEGER;
CREATE FUNCTION poly_out(POLYGON) RETURNS CSTRING;
CREATE FUNCTION poly_overabove(POLYGON, POLYGON) RETURNS BOOLEAN;
CREATE FUNCTION poly_overbelow(POLYGON, POLYGON) RETURNS BOOLEAN;
CREATE FUNCTION poly_overlap(POLYGON, POLYGON) RETURNS BOOLEAN;
CREATE FUNCTION poly_overleft(POLYGON, POLYGON) RETURNS BOOLEAN;
CREATE FUNCTION poly_overright(POLYGON, POLYGON) RETURNS BOOLEAN;
CREATE FUNCTION poly_recv(INTERNAL) RETURNS POLYGON;
CREATE FUNCTION poly_right(POLYGON, POLYGON) RETURNS BOOLEAN;
CREATE FUNCTION poly_same(POLYGON, POLYGON) RETURNS BOOLEAN;
CREATE FUNCTION poly_send(POLYGON) RETURNS BYTEA;
CREATE FUNCTION polygon(BOX) RETURNS POLYGON;
CREATE FUNCTION polygon(CIRCLE) RETURNS POLYGON;
CREATE FUNCTION polygon(INTEGER, CIRCLE) RETURNS POLYGON;
CREATE FUNCTION polygon(PATH) RETURNS POLYGON;
CREATE FUNCTION popen(PATH) RETURNS PATH;
CREATE FUNCTION position(BIT, BIT) RETURNS INTEGER;
CREATE FUNCTION position(BYTEA, BYTEA) RETURNS INTEGER;
CREATE FUNCTION position(TEXT, TEXT) RETURNS INTEGER;
CREATE FUNCTION positionjoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION positionsel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION postgresql_fdw_validator(TEXT[], OID) RETURNS BOOLEAN;
CREATE FUNCTION pow(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION pow(NUMERIC, NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION power(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION power(NUMERIC, NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION prsd_end(INTERNAL) RETURNS VOID;
CREATE FUNCTION prsd_headline(INTERNAL, INTERNAL, TSQUERY) RETURNS INTERNAL;
CREATE FUNCTION prsd_lextype(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION prsd_nexttoken(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION prsd_start(INTERNAL, INTEGER) RETURNS INTERNAL;
CREATE FUNCTION pt_contained_circle(POINT, CIRCLE) RETURNS BOOLEAN;
CREATE FUNCTION pt_contained_poly(POINT, POLYGON) RETURNS BOOLEAN;
CREATE FUNCTION query_to_xml(query TEXT, nulls BOOLEAN, tableforest BOOLEAN, targetns TEXT) RETURNS XML;
CREATE FUNCTION query_to_xml_and_xmlschema(query TEXT, nulls BOOLEAN, tableforest BOOLEAN, targetns TEXT) RETURNS XML;
CREATE FUNCTION query_to_xmlschema(query TEXT, nulls BOOLEAN, tableforest BOOLEAN, targetns TEXT) RETURNS XML;
CREATE FUNCTION querytree(TSQUERY) RETURNS TEXT;
CREATE FUNCTION quote_ident(TEXT) RETURNS TEXT;
CREATE FUNCTION quote_literal(ANYELEMENT) RETURNS TEXT;
CREATE FUNCTION quote_literal(TEXT) RETURNS TEXT;
CREATE FUNCTION quote_nullable(ANYELEMENT) RETURNS TEXT;
CREATE FUNCTION quote_nullable(TEXT) RETURNS TEXT;
CREATE FUNCTION radians(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION radius(CIRCLE) RETURNS DOUBLE PRECISION;
CREATE FUNCTION random() RETURNS DOUBLE PRECISION;
CREATE FUNCTION range_adjacent(ANYRANGE, ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION range_after(ANYRANGE, ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION range_before(ANYRANGE, ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION range_cmp(ANYRANGE, ANYRANGE) RETURNS INTEGER;
CREATE FUNCTION range_contained_by(ANYRANGE, ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION range_contains(ANYRANGE, ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION range_contains_elem(ANYRANGE, ANYELEMENT) RETURNS BOOLEAN;
CREATE FUNCTION range_eq(ANYRANGE, ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION range_ge(ANYRANGE, ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION range_gist_compress(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION range_gist_consistent(INTERNAL, ANYRANGE, INTEGER, OID, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION range_gist_decompress(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION range_gist_fetch(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION range_gist_penalty(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION range_gist_picksplit(INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION range_gist_same(ANYRANGE, ANYRANGE, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION range_gist_union(INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION range_gt(ANYRANGE, ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION range_in(CSTRING, OID, INTEGER) RETURNS ANYRANGE;
CREATE FUNCTION range_intersect(ANYRANGE, ANYRANGE) RETURNS ANYRANGE;
CREATE FUNCTION range_le(ANYRANGE, ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION range_lt(ANYRANGE, ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION range_merge(ANYRANGE, ANYRANGE) RETURNS ANYRANGE;
CREATE FUNCTION range_minus(ANYRANGE, ANYRANGE) RETURNS ANYRANGE;
CREATE FUNCTION range_ne(ANYRANGE, ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION range_out(ANYRANGE) RETURNS CSTRING;
CREATE FUNCTION range_overlaps(ANYRANGE, ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION range_overleft(ANYRANGE, ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION range_overright(ANYRANGE, ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION range_recv(INTERNAL, OID, INTEGER) RETURNS ANYRANGE;
CREATE FUNCTION range_send(ANYRANGE) RETURNS BYTEA;
CREATE FUNCTION range_typanalyze(INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION range_union(ANYRANGE, ANYRANGE) RETURNS ANYRANGE;
CREATE FUNCTION rangesel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION rank("any") RETURNS BIGINT;
CREATE FUNCTION rank() RETURNS BIGINT;
CREATE FUNCTION rank_final(INTERNAL, "any") RETURNS BIGINT;
CREATE FUNCTION record_eq(RECORD, RECORD) RETURNS BOOLEAN;
CREATE FUNCTION record_ge(RECORD, RECORD) RETURNS BOOLEAN;
CREATE FUNCTION record_gt(RECORD, RECORD) RETURNS BOOLEAN;
CREATE FUNCTION record_image_eq(RECORD, RECORD) RETURNS BOOLEAN;
CREATE FUNCTION record_image_ge(RECORD, RECORD) RETURNS BOOLEAN;
CREATE FUNCTION record_image_gt(RECORD, RECORD) RETURNS BOOLEAN;
CREATE FUNCTION record_image_le(RECORD, RECORD) RETURNS BOOLEAN;
CREATE FUNCTION record_image_lt(RECORD, RECORD) RETURNS BOOLEAN;
CREATE FUNCTION record_image_ne(RECORD, RECORD) RETURNS BOOLEAN;
CREATE FUNCTION record_in(CSTRING, OID, INTEGER) RETURNS RECORD;
CREATE FUNCTION record_le(RECORD, RECORD) RETURNS BOOLEAN;
CREATE FUNCTION record_lt(RECORD, RECORD) RETURNS BOOLEAN;
CREATE FUNCTION record_ne(RECORD, RECORD) RETURNS BOOLEAN;
CREATE FUNCTION record_out(RECORD) RETURNS CSTRING;
CREATE FUNCTION record_recv(INTERNAL, OID, INTEGER) RETURNS RECORD;
CREATE FUNCTION record_send(RECORD) RETURNS BYTEA;
CREATE FUNCTION regclass(TEXT) RETURNS REGCLASS;
CREATE FUNCTION regclassin(CSTRING) RETURNS REGCLASS;
CREATE FUNCTION regclassout(REGCLASS) RETURNS CSTRING;
CREATE FUNCTION regclassrecv(INTERNAL) RETURNS REGCLASS;
CREATE FUNCTION regclasssend(REGCLASS) RETURNS BYTEA;
CREATE FUNCTION regconfigin(CSTRING) RETURNS REGCONFIG;
CREATE FUNCTION regconfigout(REGCONFIG) RETURNS CSTRING;
CREATE FUNCTION regconfigrecv(INTERNAL) RETURNS REGCONFIG;
CREATE FUNCTION regconfigsend(REGCONFIG) RETURNS BYTEA;
CREATE FUNCTION regdictionaryin(CSTRING) RETURNS REGDICTIONARY;
CREATE FUNCTION regdictionaryout(REGDICTIONARY) RETURNS CSTRING;
CREATE FUNCTION regdictionaryrecv(INTERNAL) RETURNS REGDICTIONARY;
CREATE FUNCTION regdictionarysend(REGDICTIONARY) RETURNS BYTEA;
CREATE FUNCTION regexeqjoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION regexeqsel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION regexnejoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION regexnesel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION regexp_matches(TEXT, TEXT) RETURNS SETOF TEXT[];
CREATE FUNCTION regexp_matches(TEXT, TEXT, TEXT) RETURNS SETOF TEXT[];
CREATE FUNCTION regexp_replace(TEXT, TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION regexp_replace(TEXT, TEXT, TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION regexp_split_to_array(TEXT, TEXT) RETURNS TEXT[];
CREATE FUNCTION regexp_split_to_array(TEXT, TEXT, TEXT) RETURNS TEXT[];
CREATE FUNCTION regexp_split_to_table(TEXT, TEXT) RETURNS SETOF TEXT;
CREATE FUNCTION regexp_split_to_table(TEXT, TEXT, TEXT) RETURNS SETOF TEXT;
CREATE FUNCTION regnamespacein(CSTRING) RETURNS REGNAMESPACE;
CREATE FUNCTION regnamespaceout(REGNAMESPACE) RETURNS CSTRING;
CREATE FUNCTION regnamespacerecv(INTERNAL) RETURNS REGNAMESPACE;
CREATE FUNCTION regnamespacesend(REGNAMESPACE) RETURNS BYTEA;
CREATE FUNCTION regoperatorin(CSTRING) RETURNS REGOPERATOR;
CREATE FUNCTION regoperatorout(REGOPERATOR) RETURNS CSTRING;
CREATE FUNCTION regoperatorrecv(INTERNAL) RETURNS REGOPERATOR;
CREATE FUNCTION regoperatorsend(REGOPERATOR) RETURNS BYTEA;
CREATE FUNCTION regoperin(CSTRING) RETURNS REGOPER;
CREATE FUNCTION regoperout(REGOPER) RETURNS CSTRING;
CREATE FUNCTION regoperrecv(INTERNAL) RETURNS REGOPER;
CREATE FUNCTION regopersend(REGOPER) RETURNS BYTEA;
CREATE FUNCTION regprocedurein(CSTRING) RETURNS REGPROCEDURE;
CREATE FUNCTION regprocedureout(REGPROCEDURE) RETURNS CSTRING;
CREATE FUNCTION regprocedurerecv(INTERNAL) RETURNS REGPROCEDURE;
CREATE FUNCTION regproceduresend(REGPROCEDURE) RETURNS BYTEA;
CREATE FUNCTION regprocin(CSTRING) RETURNS REGPROC;
CREATE FUNCTION regprocout(REGPROC) RETURNS CSTRING;
CREATE FUNCTION regprocrecv(INTERNAL) RETURNS REGPROC;
CREATE FUNCTION regprocsend(REGPROC) RETURNS BYTEA;
CREATE FUNCTION regr_avgx(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION regr_avgy(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION regr_count(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS BIGINT;
CREATE FUNCTION regr_intercept(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION regr_r2(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION regr_slope(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION regr_sxx(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION regr_sxy(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION regr_syy(DOUBLE PRECISION, DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION regrolein(CSTRING) RETURNS REGROLE;
CREATE FUNCTION regroleout(REGROLE) RETURNS CSTRING;
CREATE FUNCTION regrolerecv(INTERNAL) RETURNS REGROLE;
CREATE FUNCTION regrolesend(REGROLE) RETURNS BYTEA;
CREATE FUNCTION regtypein(CSTRING) RETURNS REGTYPE;
CREATE FUNCTION regtypeout(REGTYPE) RETURNS CSTRING;
CREATE FUNCTION regtyperecv(INTERNAL) RETURNS REGTYPE;
CREATE FUNCTION regtypesend(REGTYPE) RETURNS BYTEA;
CREATE FUNCTION reltime(INTERVAL) RETURNS RELTIME;
CREATE FUNCTION reltimeeq(RELTIME, RELTIME) RETURNS BOOLEAN;
CREATE FUNCTION reltimege(RELTIME, RELTIME) RETURNS BOOLEAN;
CREATE FUNCTION reltimegt(RELTIME, RELTIME) RETURNS BOOLEAN;
CREATE FUNCTION reltimein(CSTRING) RETURNS RELTIME;
CREATE FUNCTION reltimele(RELTIME, RELTIME) RETURNS BOOLEAN;
CREATE FUNCTION reltimelt(RELTIME, RELTIME) RETURNS BOOLEAN;
CREATE FUNCTION reltimene(RELTIME, RELTIME) RETURNS BOOLEAN;
CREATE FUNCTION reltimeout(RELTIME) RETURNS CSTRING;
CREATE FUNCTION reltimerecv(INTERNAL) RETURNS RELTIME;
CREATE FUNCTION reltimesend(RELTIME) RETURNS BYTEA;
CREATE FUNCTION repeat(TEXT, INTEGER) RETURNS TEXT;
CREATE FUNCTION replace(TEXT, TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION reverse(TEXT) RETURNS TEXT;
CREATE FUNCTION "right"(TEXT, INTEGER) RETURNS TEXT;
CREATE FUNCTION round(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION round(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION round(NUMERIC, INTEGER) RETURNS NUMERIC;
CREATE FUNCTION row_number() RETURNS BIGINT;
CREATE FUNCTION row_security_active(OID) RETURNS BOOLEAN;
CREATE FUNCTION row_security_active(TEXT) RETURNS BOOLEAN;
CREATE FUNCTION row_to_json(RECORD) RETURNS JSON;
CREATE FUNCTION row_to_json(RECORD, BOOLEAN) RETURNS JSON;
CREATE FUNCTION rpad(TEXT, INTEGER) RETURNS TEXT;
CREATE FUNCTION rpad(TEXT, INTEGER, TEXT) RETURNS TEXT;
CREATE FUNCTION rtrim(TEXT) RETURNS TEXT;
CREATE FUNCTION rtrim(TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION scalargtjoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION scalargtsel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION scalarltjoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION scalarltsel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION schema_to_xml(schema NAME, nulls BOOLEAN, tableforest BOOLEAN, targetns TEXT) RETURNS XML;
CREATE FUNCTION schema_to_xml_and_xmlschema(schema NAME, nulls BOOLEAN, tableforest BOOLEAN, targetns TEXT) RETURNS XML;
CREATE FUNCTION schema_to_xmlschema(schema NAME, nulls BOOLEAN, tableforest BOOLEAN, targetns TEXT) RETURNS XML;
CREATE FUNCTION "session_user"() RETURNS NAME;
CREATE FUNCTION set_bit(BIT, INTEGER, INTEGER) RETURNS BIT;
CREATE FUNCTION set_bit(BYTEA, INTEGER, INTEGER) RETURNS BYTEA;
CREATE FUNCTION set_byte(BYTEA, INTEGER, INTEGER) RETURNS BYTEA;
CREATE FUNCTION set_config(TEXT, TEXT, BOOLEAN) RETURNS TEXT;
CREATE FUNCTION set_masklen(CIDR, INTEGER) RETURNS CIDR;
CREATE FUNCTION set_masklen(INET, INTEGER) RETURNS INET;
CREATE FUNCTION setseed(DOUBLE PRECISION) RETURNS VOID;
CREATE FUNCTION setval(REGCLASS, BIGINT) RETURNS BIGINT;
CREATE FUNCTION setval(REGCLASS, BIGINT, BOOLEAN) RETURNS BIGINT;
CREATE FUNCTION setweight(TSVECTOR, "char") RETURNS TSVECTOR;
CREATE FUNCTION shell_in(CSTRING) RETURNS OPAQUE;
CREATE FUNCTION shell_out(OPAQUE) RETURNS CSTRING;
CREATE FUNCTION shift_jis_2004_to_euc_jis_2004(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION shift_jis_2004_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION shobj_description(OID, NAME) RETURNS TEXT;
CREATE FUNCTION sign(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION sign(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION similar_escape(TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION sin(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION sjis_to_euc_jp(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION sjis_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION sjis_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION slope(POINT, POINT) RETURNS DOUBLE PRECISION;
CREATE FUNCTION smgreq(SMGR, SMGR) RETURNS BOOLEAN;
CREATE FUNCTION smgrin(CSTRING) RETURNS SMGR;
CREATE FUNCTION smgrne(SMGR, SMGR) RETURNS BOOLEAN;
CREATE FUNCTION smgrout(SMGR) RETURNS CSTRING;
CREATE FUNCTION spg_kd_choose(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spg_kd_config(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spg_kd_inner_consistent(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spg_kd_picksplit(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spg_quad_choose(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spg_quad_config(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spg_quad_inner_consistent(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spg_quad_leaf_consistent(INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION spg_quad_picksplit(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spg_range_quad_choose(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spg_range_quad_config(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spg_range_quad_inner_consistent(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spg_range_quad_leaf_consistent(INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION spg_range_quad_picksplit(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spg_text_choose(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spg_text_config(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spg_text_inner_consistent(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spg_text_leaf_consistent(INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION spg_text_picksplit(INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spgbeginscan(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION spgbuild(INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION spgbuildempty(INTERNAL) RETURNS VOID;
CREATE FUNCTION spgbulkdelete(INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION spgcanreturn(INTERNAL, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION spgcostestimate(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spgendscan(INTERNAL) RETURNS VOID;
CREATE FUNCTION spggetbitmap(INTERNAL, INTERNAL) RETURNS BIGINT;
CREATE FUNCTION spggettuple(INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION spginsert(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION spgmarkpos(INTERNAL) RETURNS VOID;
CREATE FUNCTION spgoptions(TEXT[], BOOLEAN) RETURNS BYTEA;
CREATE FUNCTION spgrescan(INTERNAL, INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS VOID;
CREATE FUNCTION spgrestrpos(INTERNAL) RETURNS VOID;
CREATE FUNCTION spgvacuumcleanup(INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION split_part(TEXT, TEXT, INTEGER) RETURNS TEXT;
CREATE FUNCTION sqrt(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION sqrt(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION statement_timestamp() RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION stddev(BIGINT) RETURNS NUMERIC;
CREATE FUNCTION stddev(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION stddev(INTEGER) RETURNS NUMERIC;
CREATE FUNCTION stddev(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION stddev(REAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION stddev(SMALLINT) RETURNS NUMERIC;
CREATE FUNCTION stddev_pop(BIGINT) RETURNS NUMERIC;
CREATE FUNCTION stddev_pop(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION stddev_pop(INTEGER) RETURNS NUMERIC;
CREATE FUNCTION stddev_pop(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION stddev_pop(REAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION stddev_pop(SMALLINT) RETURNS NUMERIC;
CREATE FUNCTION stddev_samp(BIGINT) RETURNS NUMERIC;
CREATE FUNCTION stddev_samp(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION stddev_samp(INTEGER) RETURNS NUMERIC;
CREATE FUNCTION stddev_samp(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION stddev_samp(REAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION stddev_samp(SMALLINT) RETURNS NUMERIC;
CREATE FUNCTION string_agg(BYTEA, BYTEA) RETURNS BYTEA;
CREATE FUNCTION string_agg(TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION string_agg_finalfn(INTERNAL) RETURNS TEXT;
CREATE FUNCTION string_agg_transfn(INTERNAL, TEXT, TEXT) RETURNS INTERNAL;
CREATE FUNCTION string_to_array(TEXT, TEXT) RETURNS TEXT[];
CREATE FUNCTION string_to_array(TEXT, TEXT, TEXT) RETURNS TEXT[];
CREATE FUNCTION strip(TSVECTOR) RETURNS TSVECTOR;
CREATE FUNCTION strpos(TEXT, TEXT) RETURNS INTEGER;
CREATE FUNCTION substr(BYTEA, INTEGER) RETURNS BYTEA;
CREATE FUNCTION substr(BYTEA, INTEGER, INTEGER) RETURNS BYTEA;
CREATE FUNCTION substr(TEXT, INTEGER) RETURNS TEXT;
CREATE FUNCTION substr(TEXT, INTEGER, INTEGER) RETURNS TEXT;
CREATE FUNCTION substring(BIT, INTEGER) RETURNS BIT;
CREATE FUNCTION substring(BIT, INTEGER, INTEGER) RETURNS BIT;
CREATE FUNCTION substring(BYTEA, INTEGER) RETURNS BYTEA;
CREATE FUNCTION substring(BYTEA, INTEGER, INTEGER) RETURNS BYTEA;
CREATE FUNCTION substring(TEXT, INTEGER) RETURNS TEXT;
CREATE FUNCTION substring(TEXT, INTEGER, INTEGER) RETURNS TEXT;
CREATE FUNCTION substring(TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION substring(TEXT, TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION sum(BIGINT) RETURNS NUMERIC;
CREATE FUNCTION sum(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION sum(INTEGER) RETURNS BIGINT;
CREATE FUNCTION sum(INTERVAL) RETURNS INTERVAL;
CREATE FUNCTION sum(MONEY) RETURNS MONEY;
CREATE FUNCTION sum(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION sum(REAL) RETURNS REAL;
CREATE FUNCTION sum(SMALLINT) RETURNS BIGINT;
CREATE FUNCTION suppress_redundant_updates_trigger() RETURNS TRIGGER;
CREATE FUNCTION system(INTERNAL) RETURNS TSM_HANDLER;
CREATE FUNCTION table_to_xml(tbl REGCLASS, nulls BOOLEAN, tableforest BOOLEAN, targetns TEXT) RETURNS XML;
CREATE FUNCTION table_to_xml_and_xmlschema(tbl REGCLASS, nulls BOOLEAN, tableforest BOOLEAN, targetns TEXT) RETURNS XML;
CREATE FUNCTION table_to_xmlschema(tbl REGCLASS, nulls BOOLEAN, tableforest BOOLEAN, targetns TEXT) RETURNS XML;
CREATE FUNCTION tan(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION text("char") RETURNS TEXT;
CREATE FUNCTION text(BOOLEAN) RETURNS TEXT;
CREATE FUNCTION text(CHAR) RETURNS TEXT;
CREATE FUNCTION text(INET) RETURNS TEXT;
CREATE FUNCTION text(NAME) RETURNS TEXT;
CREATE FUNCTION text(XML) RETURNS TEXT;
CREATE FUNCTION text_ge(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION text_gt(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION text_larger(TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION text_le(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION text_lt(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION text_pattern_ge(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION text_pattern_gt(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION text_pattern_le(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION text_pattern_lt(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION text_smaller(TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION textanycat(TEXT, ANYNONARRAY) RETURNS TEXT;
CREATE FUNCTION textcat(TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION texteq(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION texticlike(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION texticnlike(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION texticregexeq(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION texticregexne(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION textin(CSTRING) RETURNS TEXT;
CREATE FUNCTION textlen(TEXT) RETURNS INTEGER;
CREATE FUNCTION textlike(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION textne(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION textnlike(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION textout(TEXT) RETURNS CSTRING;
CREATE FUNCTION textrecv(INTERNAL) RETURNS TEXT;
CREATE FUNCTION textregexeq(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION textregexne(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION textsend(TEXT) RETURNS BYTEA;
CREATE FUNCTION thesaurus_init(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION thesaurus_lexize(INTERNAL, INTERNAL, INTERNAL, INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION tideq(TID, TID) RETURNS BOOLEAN;
CREATE FUNCTION tidge(TID, TID) RETURNS BOOLEAN;
CREATE FUNCTION tidgt(TID, TID) RETURNS BOOLEAN;
CREATE FUNCTION tidin(CSTRING) RETURNS TID;
CREATE FUNCTION tidlarger(TID, TID) RETURNS TID;
CREATE FUNCTION tidle(TID, TID) RETURNS BOOLEAN;
CREATE FUNCTION tidlt(TID, TID) RETURNS BOOLEAN;
CREATE FUNCTION tidne(TID, TID) RETURNS BOOLEAN;
CREATE FUNCTION tidout(TID) RETURNS CSTRING;
CREATE FUNCTION tidrecv(INTERNAL) RETURNS TID;
CREATE FUNCTION tidsend(TID) RETURNS BYTEA;
CREATE FUNCTION tidsmaller(TID, TID) RETURNS TID;
CREATE FUNCTION time(ABSTIME) RETURNS TIME;
CREATE FUNCTION time(INTERVAL) RETURNS TIME;
CREATE FUNCTION time(TIME WITH TIME ZONE) RETURNS TIME;
CREATE FUNCTION time(TIME, INTEGER) RETURNS TIME;
CREATE FUNCTION time(TIMESTAMP WITH TIME ZONE) RETURNS TIME;
CREATE FUNCTION time(TIMESTAMP) RETURNS TIME;
CREATE FUNCTION time_cmp(TIME, TIME) RETURNS INTEGER;
CREATE FUNCTION time_eq(TIME, TIME) RETURNS BOOLEAN;
CREATE FUNCTION time_ge(TIME, TIME) RETURNS BOOLEAN;
CREATE FUNCTION time_gt(TIME, TIME) RETURNS BOOLEAN;
CREATE FUNCTION time_hash(TIME) RETURNS INTEGER;
CREATE FUNCTION time_in(CSTRING, OID, INTEGER) RETURNS TIME;
CREATE FUNCTION time_larger(TIME, TIME) RETURNS TIME;
CREATE FUNCTION time_le(TIME, TIME) RETURNS BOOLEAN;
CREATE FUNCTION time_lt(TIME, TIME) RETURNS BOOLEAN;
CREATE FUNCTION time_mi_interval(TIME, INTERVAL) RETURNS TIME;
CREATE FUNCTION time_mi_time(TIME, TIME) RETURNS INTERVAL;
CREATE FUNCTION time_ne(TIME, TIME) RETURNS BOOLEAN;
CREATE FUNCTION time_out(TIME) RETURNS CSTRING;
CREATE FUNCTION time_pl_interval(TIME, INTERVAL) RETURNS TIME;
CREATE FUNCTION time_recv(INTERNAL, OID, INTEGER) RETURNS TIME;
CREATE FUNCTION time_send(TIME) RETURNS BYTEA;
CREATE FUNCTION time_smaller(TIME, TIME) RETURNS TIME;
CREATE FUNCTION time_transform(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION timedate_pl(TIME, DATE) RETURNS TIMESTAMP;
CREATE FUNCTION timemi(ABSTIME, RELTIME) RETURNS ABSTIME;
CREATE FUNCTION timenow() RETURNS ABSTIME;
CREATE FUNCTION timeofday() RETURNS TEXT;
CREATE FUNCTION timepl(ABSTIME, RELTIME) RETURNS ABSTIME;
CREATE FUNCTION timestamp(ABSTIME) RETURNS TIMESTAMP;
CREATE FUNCTION timestamp(DATE) RETURNS TIMESTAMP;
CREATE FUNCTION timestamp(DATE, TIME) RETURNS TIMESTAMP;
CREATE FUNCTION timestamp(TIMESTAMP WITH TIME ZONE) RETURNS TIMESTAMP;
CREATE FUNCTION timestamp(TIMESTAMP, INTEGER) RETURNS TIMESTAMP;
CREATE FUNCTION timestamp_cmp(TIMESTAMP, TIMESTAMP) RETURNS INTEGER;
CREATE FUNCTION timestamp_cmp_date(TIMESTAMP, DATE) RETURNS INTEGER;
CREATE FUNCTION timestamp_cmp_timestamptz(TIMESTAMP, TIMESTAMP WITH TIME ZONE) RETURNS INTEGER;
CREATE FUNCTION timestamp_eq(TIMESTAMP, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_eq_date(TIMESTAMP, DATE) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_eq_timestamptz(TIMESTAMP, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_ge(TIMESTAMP, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_ge_date(TIMESTAMP, DATE) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_ge_timestamptz(TIMESTAMP, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_gt(TIMESTAMP, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_gt_date(TIMESTAMP, DATE) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_gt_timestamptz(TIMESTAMP, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_hash(TIMESTAMP) RETURNS INTEGER;
CREATE FUNCTION timestamp_in(CSTRING, OID, INTEGER) RETURNS TIMESTAMP;
CREATE FUNCTION timestamp_izone_transform(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION timestamp_larger(TIMESTAMP, TIMESTAMP) RETURNS TIMESTAMP;
CREATE FUNCTION timestamp_le(TIMESTAMP, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_le_date(TIMESTAMP, DATE) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_le_timestamptz(TIMESTAMP, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_lt(TIMESTAMP, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_lt_date(TIMESTAMP, DATE) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_lt_timestamptz(TIMESTAMP, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_mi(TIMESTAMP, TIMESTAMP) RETURNS INTERVAL;
CREATE FUNCTION timestamp_mi_interval(TIMESTAMP, INTERVAL) RETURNS TIMESTAMP;
CREATE FUNCTION timestamp_ne(TIMESTAMP, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_ne_date(TIMESTAMP, DATE) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_ne_timestamptz(TIMESTAMP, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timestamp_out(TIMESTAMP) RETURNS CSTRING;
CREATE FUNCTION timestamp_pl_interval(TIMESTAMP, INTERVAL) RETURNS TIMESTAMP;
CREATE FUNCTION timestamp_recv(INTERNAL, OID, INTEGER) RETURNS TIMESTAMP;
CREATE FUNCTION timestamp_send(TIMESTAMP) RETURNS BYTEA;
CREATE FUNCTION timestamp_smaller(TIMESTAMP, TIMESTAMP) RETURNS TIMESTAMP;
CREATE FUNCTION timestamp_sortsupport(INTERNAL) RETURNS VOID;
CREATE FUNCTION timestamp_transform(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION timestamp_zone_transform(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION timestamptypmodin(CSTRING[]) RETURNS INTEGER;
CREATE FUNCTION timestamptypmodout(INTEGER) RETURNS CSTRING;
CREATE FUNCTION timestamptz(ABSTIME) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION timestamptz(DATE) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION timestamptz(DATE, TIME WITH TIME ZONE) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION timestamptz(DATE, TIME) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION timestamptz(TIMESTAMP WITH TIME ZONE, INTEGER) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION timestamptz(TIMESTAMP) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION timestamptz_cmp(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) RETURNS INTEGER;
CREATE FUNCTION timestamptz_cmp_date(TIMESTAMP WITH TIME ZONE, DATE) RETURNS INTEGER;
CREATE FUNCTION timestamptz_cmp_timestamp(TIMESTAMP WITH TIME ZONE, TIMESTAMP) RETURNS INTEGER;
CREATE FUNCTION timestamptz_eq(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_eq_date(TIMESTAMP WITH TIME ZONE, DATE) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_eq_timestamp(TIMESTAMP WITH TIME ZONE, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_ge(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_ge_date(TIMESTAMP WITH TIME ZONE, DATE) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_ge_timestamp(TIMESTAMP WITH TIME ZONE, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_gt(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_gt_date(TIMESTAMP WITH TIME ZONE, DATE) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_gt_timestamp(TIMESTAMP WITH TIME ZONE, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_in(CSTRING, OID, INTEGER) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION timestamptz_larger(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION timestamptz_le(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_le_date(TIMESTAMP WITH TIME ZONE, DATE) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_le_timestamp(TIMESTAMP WITH TIME ZONE, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_lt(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_lt_date(TIMESTAMP WITH TIME ZONE, DATE) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_lt_timestamp(TIMESTAMP WITH TIME ZONE, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_mi(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) RETURNS INTERVAL;
CREATE FUNCTION timestamptz_mi_interval(TIMESTAMP WITH TIME ZONE, INTERVAL) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION timestamptz_ne(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_ne_date(TIMESTAMP WITH TIME ZONE, DATE) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_ne_timestamp(TIMESTAMP WITH TIME ZONE, TIMESTAMP) RETURNS BOOLEAN;
CREATE FUNCTION timestamptz_out(TIMESTAMP WITH TIME ZONE) RETURNS CSTRING;
CREATE FUNCTION timestamptz_pl_interval(TIMESTAMP WITH TIME ZONE, INTERVAL) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION timestamptz_recv(INTERNAL, OID, INTEGER) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION timestamptz_send(TIMESTAMP WITH TIME ZONE) RETURNS BYTEA;
CREATE FUNCTION timestamptz_smaller(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION timestamptztypmodin(CSTRING[]) RETURNS INTEGER;
CREATE FUNCTION timestamptztypmodout(INTEGER) RETURNS CSTRING;
CREATE FUNCTION timetypmodin(CSTRING[]) RETURNS INTEGER;
CREATE FUNCTION timetypmodout(INTEGER) RETURNS CSTRING;
CREATE FUNCTION timetz(TIME WITH TIME ZONE, INTEGER) RETURNS TIME WITH TIME ZONE;
CREATE FUNCTION timetz(TIME) RETURNS TIME WITH TIME ZONE;
CREATE FUNCTION timetz(TIMESTAMP WITH TIME ZONE) RETURNS TIME WITH TIME ZONE;
CREATE FUNCTION timetz_cmp(TIME WITH TIME ZONE, TIME WITH TIME ZONE) RETURNS INTEGER;
CREATE FUNCTION timetz_eq(TIME WITH TIME ZONE, TIME WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timetz_ge(TIME WITH TIME ZONE, TIME WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timetz_gt(TIME WITH TIME ZONE, TIME WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timetz_hash(TIME WITH TIME ZONE) RETURNS INTEGER;
CREATE FUNCTION timetz_in(CSTRING, OID, INTEGER) RETURNS TIME WITH TIME ZONE;
CREATE FUNCTION timetz_larger(TIME WITH TIME ZONE, TIME WITH TIME ZONE) RETURNS TIME WITH TIME ZONE;
CREATE FUNCTION timetz_le(TIME WITH TIME ZONE, TIME WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timetz_lt(TIME WITH TIME ZONE, TIME WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timetz_mi_interval(TIME WITH TIME ZONE, INTERVAL) RETURNS TIME WITH TIME ZONE;
CREATE FUNCTION timetz_ne(TIME WITH TIME ZONE, TIME WITH TIME ZONE) RETURNS BOOLEAN;
CREATE FUNCTION timetz_out(TIME WITH TIME ZONE) RETURNS CSTRING;
CREATE FUNCTION timetz_pl_interval(TIME WITH TIME ZONE, INTERVAL) RETURNS TIME WITH TIME ZONE;
CREATE FUNCTION timetz_recv(INTERNAL, OID, INTEGER) RETURNS TIME WITH TIME ZONE;
CREATE FUNCTION timetz_send(TIME WITH TIME ZONE) RETURNS BYTEA;
CREATE FUNCTION timetz_smaller(TIME WITH TIME ZONE, TIME WITH TIME ZONE) RETURNS TIME WITH TIME ZONE;
CREATE FUNCTION timetzdate_pl(TIME WITH TIME ZONE, DATE) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION timetztypmodin(CSTRING[]) RETURNS INTEGER;
CREATE FUNCTION timetztypmodout(INTEGER) RETURNS CSTRING;
CREATE FUNCTION timezone(INTERVAL, TIME WITH TIME ZONE) RETURNS TIME WITH TIME ZONE;
CREATE FUNCTION timezone(INTERVAL, TIMESTAMP WITH TIME ZONE) RETURNS TIMESTAMP;
CREATE FUNCTION timezone(INTERVAL, TIMESTAMP) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION timezone(TEXT, TIME WITH TIME ZONE) RETURNS TIME WITH TIME ZONE;
CREATE FUNCTION timezone(TEXT, TIMESTAMP WITH TIME ZONE) RETURNS TIMESTAMP;
CREATE FUNCTION timezone(TEXT, TIMESTAMP) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION tinterval(ABSTIME, ABSTIME) RETURNS TINTERVAL;
CREATE FUNCTION tintervalct(TINTERVAL, TINTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION tintervalend(TINTERVAL) RETURNS ABSTIME;
CREATE FUNCTION tintervaleq(TINTERVAL, TINTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION tintervalge(TINTERVAL, TINTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION tintervalgt(TINTERVAL, TINTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION tintervalin(CSTRING) RETURNS TINTERVAL;
CREATE FUNCTION tintervalle(TINTERVAL, TINTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION tintervalleneq(TINTERVAL, RELTIME) RETURNS BOOLEAN;
CREATE FUNCTION tintervallenge(TINTERVAL, RELTIME) RETURNS BOOLEAN;
CREATE FUNCTION tintervallengt(TINTERVAL, RELTIME) RETURNS BOOLEAN;
CREATE FUNCTION tintervallenle(TINTERVAL, RELTIME) RETURNS BOOLEAN;
CREATE FUNCTION tintervallenlt(TINTERVAL, RELTIME) RETURNS BOOLEAN;
CREATE FUNCTION tintervallenne(TINTERVAL, RELTIME) RETURNS BOOLEAN;
CREATE FUNCTION tintervallt(TINTERVAL, TINTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION tintervalne(TINTERVAL, TINTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION tintervalout(TINTERVAL) RETURNS CSTRING;
CREATE FUNCTION tintervalov(TINTERVAL, TINTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION tintervalrecv(INTERNAL) RETURNS TINTERVAL;
CREATE FUNCTION tintervalrel(TINTERVAL) RETURNS RELTIME;
CREATE FUNCTION tintervalsame(TINTERVAL, TINTERVAL) RETURNS BOOLEAN;
CREATE FUNCTION tintervalsend(TINTERVAL) RETURNS BYTEA;
CREATE FUNCTION tintervalstart(TINTERVAL) RETURNS ABSTIME;
CREATE FUNCTION to_ascii(TEXT) RETURNS TEXT;
CREATE FUNCTION to_ascii(TEXT, INTEGER) RETURNS TEXT;
CREATE FUNCTION to_ascii(TEXT, NAME) RETURNS TEXT;
CREATE FUNCTION to_char(BIGINT, TEXT) RETURNS TEXT;
CREATE FUNCTION to_char(DOUBLE PRECISION, TEXT) RETURNS TEXT;
CREATE FUNCTION to_char(INTEGER, TEXT) RETURNS TEXT;
CREATE FUNCTION to_char(INTERVAL, TEXT) RETURNS TEXT;
CREATE FUNCTION to_char(NUMERIC, TEXT) RETURNS TEXT;
CREATE FUNCTION to_char(REAL, TEXT) RETURNS TEXT;
CREATE FUNCTION to_char(TIMESTAMP WITH TIME ZONE, TEXT) RETURNS TEXT;
CREATE FUNCTION to_char(TIMESTAMP, TEXT) RETURNS TEXT;
CREATE FUNCTION to_date(TEXT, TEXT) RETURNS DATE;
CREATE FUNCTION to_hex(BIGINT) RETURNS TEXT;
CREATE FUNCTION to_hex(INTEGER) RETURNS TEXT;
CREATE FUNCTION to_json(ANYELEMENT) RETURNS JSON;
CREATE FUNCTION to_jsonb(ANYELEMENT) RETURNS JSONB;
CREATE FUNCTION to_number(TEXT, TEXT) RETURNS NUMERIC;
CREATE FUNCTION to_regclass(CSTRING) RETURNS REGCLASS;
CREATE FUNCTION to_regnamespace(CSTRING) RETURNS REGNAMESPACE;
CREATE FUNCTION to_regoper(CSTRING) RETURNS REGOPER;
CREATE FUNCTION to_regoperator(CSTRING) RETURNS REGOPERATOR;
CREATE FUNCTION to_regproc(CSTRING) RETURNS REGPROC;
CREATE FUNCTION to_regprocedure(CSTRING) RETURNS REGPROCEDURE;
CREATE FUNCTION to_regrole(CSTRING) RETURNS REGROLE;
CREATE FUNCTION to_regtype(CSTRING) RETURNS REGTYPE;
CREATE FUNCTION to_timestamp(DOUBLE PRECISION) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION to_timestamp(TEXT, TEXT) RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION to_tsquery(REGCONFIG, TEXT) RETURNS TSQUERY;
CREATE FUNCTION to_tsquery(TEXT) RETURNS TSQUERY;
CREATE FUNCTION to_tsvector(REGCONFIG, TEXT) RETURNS TSVECTOR;
CREATE FUNCTION to_tsvector(TEXT) RETURNS TSVECTOR;
CREATE FUNCTION transaction_timestamp() RETURNS TIMESTAMP WITH TIME ZONE;
CREATE FUNCTION translate(TEXT, TEXT, TEXT) RETURNS TEXT;
CREATE FUNCTION trigger_in(CSTRING) RETURNS TRIGGER;
CREATE FUNCTION trigger_out(TRIGGER) RETURNS CSTRING;
CREATE FUNCTION trunc(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION trunc(MACADDR) RETURNS MACADDR;
CREATE FUNCTION trunc(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION trunc(NUMERIC, INTEGER) RETURNS NUMERIC;
CREATE FUNCTION ts_debug(config REGCONFIG, document TEXT, alias OUT TEXT, description OUT TEXT, token OUT TEXT, dictionaries OUT REGDICTIONARY[], dictionary OUT REGDICTIONARY, lexemes OUT TEXT[]) RETURNS SETOF RECORD;
CREATE FUNCTION ts_debug(document TEXT, alias OUT TEXT, description OUT TEXT, token OUT TEXT, dictionaries OUT REGDICTIONARY[], dictionary OUT REGDICTIONARY, lexemes OUT TEXT[]) RETURNS SETOF RECORD;
CREATE FUNCTION ts_headline(REGCONFIG, TEXT, TSQUERY) RETURNS TEXT;
CREATE FUNCTION ts_headline(REGCONFIG, TEXT, TSQUERY, TEXT) RETURNS TEXT;
CREATE FUNCTION ts_headline(TEXT, TSQUERY) RETURNS TEXT;
CREATE FUNCTION ts_headline(TEXT, TSQUERY, TEXT) RETURNS TEXT;
CREATE FUNCTION ts_lexize(REGDICTIONARY, TEXT) RETURNS TEXT[];
CREATE FUNCTION ts_match_qv(TSQUERY, TSVECTOR) RETURNS BOOLEAN;
CREATE FUNCTION ts_match_tq(TEXT, TSQUERY) RETURNS BOOLEAN;
CREATE FUNCTION ts_match_tt(TEXT, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION ts_match_vq(TSVECTOR, TSQUERY) RETURNS BOOLEAN;
CREATE FUNCTION ts_parse(parser_oid OID, txt TEXT, tokid OUT INTEGER, token OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION ts_parse(parser_name TEXT, txt TEXT, tokid OUT INTEGER, token OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION ts_rank(REAL[], TSVECTOR, TSQUERY) RETURNS REAL;
CREATE FUNCTION ts_rank(REAL[], TSVECTOR, TSQUERY, INTEGER) RETURNS REAL;
CREATE FUNCTION ts_rank(TSVECTOR, TSQUERY) RETURNS REAL;
CREATE FUNCTION ts_rank(TSVECTOR, TSQUERY, INTEGER) RETURNS REAL;
CREATE FUNCTION ts_rank_cd(REAL[], TSVECTOR, TSQUERY) RETURNS REAL;
CREATE FUNCTION ts_rank_cd(REAL[], TSVECTOR, TSQUERY, INTEGER) RETURNS REAL;
CREATE FUNCTION ts_rank_cd(TSVECTOR, TSQUERY) RETURNS REAL;
CREATE FUNCTION ts_rank_cd(TSVECTOR, TSQUERY, INTEGER) RETURNS REAL;
CREATE FUNCTION ts_rewrite(TSQUERY, TEXT) RETURNS TSQUERY;
CREATE FUNCTION ts_rewrite(TSQUERY, TSQUERY, TSQUERY) RETURNS TSQUERY;
CREATE FUNCTION ts_stat(query TEXT, word OUT TEXT, ndoc OUT INTEGER, nentry OUT INTEGER) RETURNS SETOF RECORD;
CREATE FUNCTION ts_stat(query TEXT, weights TEXT, word OUT TEXT, ndoc OUT INTEGER, nentry OUT INTEGER) RETURNS SETOF RECORD;
CREATE FUNCTION ts_token_type(parser_oid OID, tokid OUT INTEGER, alias OUT TEXT, description OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION ts_token_type(parser_name TEXT, tokid OUT INTEGER, alias OUT TEXT, description OUT TEXT) RETURNS SETOF RECORD;
CREATE FUNCTION ts_typanalyze(INTERNAL) RETURNS BOOLEAN;
CREATE FUNCTION tsm_handler_in(CSTRING) RETURNS TSM_HANDLER;
CREATE FUNCTION tsm_handler_out(TSM_HANDLER) RETURNS CSTRING;
CREATE FUNCTION tsmatchjoinsel(INTERNAL, OID, INTERNAL, SMALLINT, INTERNAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION tsmatchsel(INTERNAL, OID, INTERNAL, INTEGER) RETURNS DOUBLE PRECISION;
CREATE FUNCTION tsq_mcontained(TSQUERY, TSQUERY) RETURNS BOOLEAN;
CREATE FUNCTION tsq_mcontains(TSQUERY, TSQUERY) RETURNS BOOLEAN;
CREATE FUNCTION tsquery_and(TSQUERY, TSQUERY) RETURNS TSQUERY;
CREATE FUNCTION tsquery_cmp(TSQUERY, TSQUERY) RETURNS INTEGER;
CREATE FUNCTION tsquery_eq(TSQUERY, TSQUERY) RETURNS BOOLEAN;
CREATE FUNCTION tsquery_ge(TSQUERY, TSQUERY) RETURNS BOOLEAN;
CREATE FUNCTION tsquery_gt(TSQUERY, TSQUERY) RETURNS BOOLEAN;
CREATE FUNCTION tsquery_le(TSQUERY, TSQUERY) RETURNS BOOLEAN;
CREATE FUNCTION tsquery_lt(TSQUERY, TSQUERY) RETURNS BOOLEAN;
CREATE FUNCTION tsquery_ne(TSQUERY, TSQUERY) RETURNS BOOLEAN;
CREATE FUNCTION tsquery_not(TSQUERY) RETURNS TSQUERY;
CREATE FUNCTION tsquery_or(TSQUERY, TSQUERY) RETURNS TSQUERY;
CREATE FUNCTION tsqueryin(CSTRING) RETURNS TSQUERY;
CREATE FUNCTION tsqueryout(TSQUERY) RETURNS CSTRING;
CREATE FUNCTION tsqueryrecv(INTERNAL) RETURNS TSQUERY;
CREATE FUNCTION tsquerysend(TSQUERY) RETURNS BYTEA;
CREATE FUNCTION tsrange(TIMESTAMP, TIMESTAMP) RETURNS TSRANGE;
CREATE FUNCTION tsrange(TIMESTAMP, TIMESTAMP, TEXT) RETURNS TSRANGE;
CREATE FUNCTION tsrange_subdiff(TIMESTAMP, TIMESTAMP) RETURNS DOUBLE PRECISION;
CREATE FUNCTION tstzrange(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) RETURNS TSTZRANGE;
CREATE FUNCTION tstzrange(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE, TEXT) RETURNS TSTZRANGE;
CREATE FUNCTION tstzrange_subdiff(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) RETURNS DOUBLE PRECISION;
CREATE FUNCTION tsvector_cmp(TSVECTOR, TSVECTOR) RETURNS INTEGER;
CREATE FUNCTION tsvector_concat(TSVECTOR, TSVECTOR) RETURNS TSVECTOR;
CREATE FUNCTION tsvector_eq(TSVECTOR, TSVECTOR) RETURNS BOOLEAN;
CREATE FUNCTION tsvector_ge(TSVECTOR, TSVECTOR) RETURNS BOOLEAN;
CREATE FUNCTION tsvector_gt(TSVECTOR, TSVECTOR) RETURNS BOOLEAN;
CREATE FUNCTION tsvector_le(TSVECTOR, TSVECTOR) RETURNS BOOLEAN;
CREATE FUNCTION tsvector_lt(TSVECTOR, TSVECTOR) RETURNS BOOLEAN;
CREATE FUNCTION tsvector_ne(TSVECTOR, TSVECTOR) RETURNS BOOLEAN;
CREATE FUNCTION tsvector_update_trigger() RETURNS TRIGGER;
CREATE FUNCTION tsvector_update_trigger_column() RETURNS TRIGGER;
CREATE FUNCTION tsvectorin(CSTRING) RETURNS TSVECTOR;
CREATE FUNCTION tsvectorout(TSVECTOR) RETURNS CSTRING;
CREATE FUNCTION tsvectorrecv(INTERNAL) RETURNS TSVECTOR;
CREATE FUNCTION tsvectorsend(TSVECTOR) RETURNS BYTEA;
CREATE FUNCTION txid_current() RETURNS BIGINT;
CREATE FUNCTION txid_current_snapshot() RETURNS TXID_SNAPSHOT;
CREATE FUNCTION txid_snapshot_in(CSTRING) RETURNS TXID_SNAPSHOT;
CREATE FUNCTION txid_snapshot_out(TXID_SNAPSHOT) RETURNS CSTRING;
CREATE FUNCTION txid_snapshot_recv(INTERNAL) RETURNS TXID_SNAPSHOT;
CREATE FUNCTION txid_snapshot_send(TXID_SNAPSHOT) RETURNS BYTEA;
CREATE FUNCTION txid_snapshot_xip(TXID_SNAPSHOT) RETURNS SETOF BIGINT;
CREATE FUNCTION txid_snapshot_xmax(TXID_SNAPSHOT) RETURNS BIGINT;
CREATE FUNCTION txid_snapshot_xmin(TXID_SNAPSHOT) RETURNS BIGINT;
CREATE FUNCTION txid_visible_in_snapshot(BIGINT, TXID_SNAPSHOT) RETURNS BOOLEAN;
CREATE FUNCTION uhc_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION unique_key_recheck() RETURNS TRIGGER;
CREATE FUNCTION unknownin(CSTRING) RETURNS UNKNOWN;
CREATE FUNCTION unknownout(UNKNOWN) RETURNS CSTRING;
CREATE FUNCTION unknownrecv(INTERNAL) RETURNS UNKNOWN;
CREATE FUNCTION unknownsend(UNKNOWN) RETURNS BYTEA;
CREATE FUNCTION unnest(ANYARRAY) RETURNS SETOF ANYELEMENT;
CREATE FUNCTION upper(ANYRANGE) RETURNS ANYELEMENT;
CREATE FUNCTION upper(TEXT) RETURNS TEXT;
CREATE FUNCTION upper_inc(ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION upper_inf(ANYRANGE) RETURNS BOOLEAN;
CREATE FUNCTION utf8_to_ascii(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_big5(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_euc_cn(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_euc_jis_2004(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_euc_jp(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_euc_kr(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_euc_tw(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_gb18030(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_gbk(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_iso8859(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_iso8859_1(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_johab(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_koi8r(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_koi8u(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_shift_jis_2004(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_sjis(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_uhc(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION utf8_to_win(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION uuid_cmp(UUID, UUID) RETURNS INTEGER;
CREATE FUNCTION uuid_eq(UUID, UUID) RETURNS BOOLEAN;
CREATE FUNCTION uuid_ge(UUID, UUID) RETURNS BOOLEAN;
CREATE FUNCTION uuid_gt(UUID, UUID) RETURNS BOOLEAN;
CREATE FUNCTION uuid_hash(UUID) RETURNS INTEGER;
CREATE FUNCTION uuid_in(CSTRING) RETURNS UUID;
CREATE FUNCTION uuid_le(UUID, UUID) RETURNS BOOLEAN;
CREATE FUNCTION uuid_lt(UUID, UUID) RETURNS BOOLEAN;
CREATE FUNCTION uuid_ne(UUID, UUID) RETURNS BOOLEAN;
CREATE FUNCTION uuid_out(UUID) RETURNS CSTRING;
CREATE FUNCTION uuid_recv(INTERNAL) RETURNS UUID;
CREATE FUNCTION uuid_send(UUID) RETURNS BYTEA;
CREATE FUNCTION var_pop(BIGINT) RETURNS NUMERIC;
CREATE FUNCTION var_pop(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION var_pop(INTEGER) RETURNS NUMERIC;
CREATE FUNCTION var_pop(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION var_pop(REAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION var_pop(SMALLINT) RETURNS NUMERIC;
CREATE FUNCTION var_samp(BIGINT) RETURNS NUMERIC;
CREATE FUNCTION var_samp(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION var_samp(INTEGER) RETURNS NUMERIC;
CREATE FUNCTION var_samp(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION var_samp(REAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION var_samp(SMALLINT) RETURNS NUMERIC;
CREATE FUNCTION varbit(BIT VARYING, INTEGER, BOOLEAN) RETURNS BIT VARYING;
CREATE FUNCTION varbit_in(CSTRING, OID, INTEGER) RETURNS BIT VARYING;
CREATE FUNCTION varbit_out(BIT VARYING) RETURNS CSTRING;
CREATE FUNCTION varbit_recv(INTERNAL, OID, INTEGER) RETURNS BIT VARYING;
CREATE FUNCTION varbit_send(BIT VARYING) RETURNS BYTEA;
CREATE FUNCTION varbit_transform(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION varbitcmp(BIT VARYING, BIT VARYING) RETURNS INTEGER;
CREATE FUNCTION varbiteq(BIT VARYING, BIT VARYING) RETURNS BOOLEAN;
CREATE FUNCTION varbitge(BIT VARYING, BIT VARYING) RETURNS BOOLEAN;
CREATE FUNCTION varbitgt(BIT VARYING, BIT VARYING) RETURNS BOOLEAN;
CREATE FUNCTION varbitle(BIT VARYING, BIT VARYING) RETURNS BOOLEAN;
CREATE FUNCTION varbitlt(BIT VARYING, BIT VARYING) RETURNS BOOLEAN;
CREATE FUNCTION varbitne(BIT VARYING, BIT VARYING) RETURNS BOOLEAN;
CREATE FUNCTION varbittypmodin(CSTRING[]) RETURNS INTEGER;
CREATE FUNCTION varbittypmodout(INTEGER) RETURNS CSTRING;
CREATE FUNCTION varchar(NAME) RETURNS VARCHAR;
CREATE FUNCTION varchar(VARCHAR, INTEGER, BOOLEAN) RETURNS VARCHAR;
CREATE FUNCTION varchar_transform(INTERNAL) RETURNS INTERNAL;
CREATE FUNCTION varcharin(CSTRING, OID, INTEGER) RETURNS VARCHAR;
CREATE FUNCTION varcharout(VARCHAR) RETURNS CSTRING;
CREATE FUNCTION varcharrecv(INTERNAL, OID, INTEGER) RETURNS VARCHAR;
CREATE FUNCTION varcharsend(VARCHAR) RETURNS BYTEA;
CREATE FUNCTION varchartypmodin(CSTRING[]) RETURNS INTEGER;
CREATE FUNCTION varchartypmodout(INTEGER) RETURNS CSTRING;
CREATE FUNCTION variance(BIGINT) RETURNS NUMERIC;
CREATE FUNCTION variance(DOUBLE PRECISION) RETURNS DOUBLE PRECISION;
CREATE FUNCTION variance(INTEGER) RETURNS NUMERIC;
CREATE FUNCTION variance(NUMERIC) RETURNS NUMERIC;
CREATE FUNCTION variance(REAL) RETURNS DOUBLE PRECISION;
CREATE FUNCTION variance(SMALLINT) RETURNS NUMERIC;
CREATE FUNCTION version() RETURNS TEXT;
CREATE FUNCTION void_in(CSTRING) RETURNS VOID;
CREATE FUNCTION void_out(VOID) RETURNS CSTRING;
CREATE FUNCTION void_recv(INTERNAL) RETURNS VOID;
CREATE FUNCTION void_send(VOID) RETURNS BYTEA;
CREATE FUNCTION width(BOX) RETURNS DOUBLE PRECISION;
CREATE FUNCTION width_bucket(ANYELEMENT, ANYARRAY) RETURNS INTEGER;
CREATE FUNCTION width_bucket(DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION, INTEGER) RETURNS INTEGER;
CREATE FUNCTION width_bucket(NUMERIC, NUMERIC, NUMERIC, INTEGER) RETURNS INTEGER;
CREATE FUNCTION win1250_to_latin2(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION win1250_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION win1251_to_iso(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION win1251_to_koi8r(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION win1251_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION win1251_to_win866(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION win866_to_iso(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION win866_to_koi8r(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION win866_to_mic(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION win866_to_win1251(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION win_to_utf8(INTEGER, INTEGER, CSTRING, INTERNAL, INTEGER) RETURNS VOID;
CREATE FUNCTION xideq(XID, XID) RETURNS BOOLEAN;
CREATE FUNCTION xideqint4(XID, INTEGER) RETURNS BOOLEAN;
CREATE FUNCTION xidin(CSTRING) RETURNS XID;
CREATE FUNCTION xidout(XID) RETURNS CSTRING;
CREATE FUNCTION xidrecv(INTERNAL) RETURNS XID;
CREATE FUNCTION xidsend(XID) RETURNS BYTEA;
CREATE FUNCTION xml(TEXT) RETURNS XML;
CREATE FUNCTION xml_in(CSTRING) RETURNS XML;
CREATE FUNCTION xml_is_well_formed(TEXT) RETURNS BOOLEAN;
CREATE FUNCTION xml_is_well_formed_content(TEXT) RETURNS BOOLEAN;
CREATE FUNCTION xml_is_well_formed_document(TEXT) RETURNS BOOLEAN;
CREATE FUNCTION xml_out(XML) RETURNS CSTRING;
CREATE FUNCTION xml_recv(INTERNAL) RETURNS XML;
CREATE FUNCTION xml_send(XML) RETURNS BYTEA;
CREATE FUNCTION xmlagg(XML) RETURNS XML;
CREATE FUNCTION xmlcomment(TEXT) RETURNS XML;
CREATE FUNCTION xmlconcat2(XML, XML) RETURNS XML;
CREATE FUNCTION xmlexists(TEXT, XML) RETURNS BOOLEAN;
CREATE FUNCTION xmlvalidate(XML, TEXT) RETURNS BOOLEAN;
CREATE FUNCTION xpath(TEXT, XML) RETURNS XML[];
CREATE FUNCTION xpath(TEXT, XML, TEXT[]) RETURNS XML[];
CREATE FUNCTION xpath_exists(TEXT, XML) RETURNS BOOLEAN;
CREATE FUNCTION xpath_exists(TEXT, XML, TEXT[]) RETURNS BOOLEAN;
CREATE TABLE sql_features
(
    feature_id information_schema.CHARACTER_DATA,
    feature_name information_schema.CHARACTER_DATA,
    sub_feature_id information_schema.CHARACTER_DATA,
    sub_feature_name information_schema.CHARACTER_DATA,
    is_supported information_schema.YES_OR_NO,
    is_verified_by information_schema.CHARACTER_DATA,
    comments information_schema.CHARACTER_DATA
);
CREATE TABLE sql_implementation_info
(
    implementation_info_id information_schema.CHARACTER_DATA,
    implementation_info_name information_schema.CHARACTER_DATA,
    integer_value information_schema.CARDINAL_NUMBER,
    character_value information_schema.CHARACTER_DATA,
    comments information_schema.CHARACTER_DATA
);
CREATE TABLE sql_languages
(
    sql_language_source information_schema.CHARACTER_DATA,
    sql_language_year information_schema.CHARACTER_DATA,
    sql_language_conformance information_schema.CHARACTER_DATA,
    sql_language_integrity information_schema.CHARACTER_DATA,
    sql_language_implementation information_schema.CHARACTER_DATA,
    sql_language_binding_style information_schema.CHARACTER_DATA,
    sql_language_programming_language information_schema.CHARACTER_DATA
);
CREATE TABLE sql_packages
(
    feature_id information_schema.CHARACTER_DATA,
    feature_name information_schema.CHARACTER_DATA,
    is_supported information_schema.YES_OR_NO,
    is_verified_by information_schema.CHARACTER_DATA,
    comments information_schema.CHARACTER_DATA
);
CREATE TABLE sql_parts
(
    feature_id information_schema.CHARACTER_DATA,
    feature_name information_schema.CHARACTER_DATA,
    is_supported information_schema.YES_OR_NO,
    is_verified_by information_schema.CHARACTER_DATA,
    comments information_schema.CHARACTER_DATA
);
CREATE TABLE sql_sizing
(
    sizing_id information_schema.CARDINAL_NUMBER,
    sizing_name information_schema.CHARACTER_DATA,
    supported_value information_schema.CARDINAL_NUMBER,
    comments information_schema.CHARACTER_DATA
);
CREATE TABLE sql_sizing_profiles
(
    sizing_id information_schema.CARDINAL_NUMBER,
    sizing_name information_schema.CHARACTER_DATA,
    profile_id information_schema.CHARACTER_DATA,
    required_value information_schema.CARDINAL_NUMBER,
    comments information_schema.CHARACTER_DATA
);
CREATE TABLE _pg_foreign_data_wrappers
(
    oid OID,
    fdwowner OID,
    fdwoptions TEXT[],
    foreign_data_wrapper_catalog information_schema.SQL_IDENTIFIER,
    foreign_data_wrapper_name information_schema.SQL_IDENTIFIER,
    authorization_identifier information_schema.SQL_IDENTIFIER,
    foreign_data_wrapper_language information_schema.CHARACTER_DATA
);
CREATE TABLE _pg_foreign_servers
(
    oid OID,
    srvoptions TEXT[],
    foreign_server_catalog information_schema.SQL_IDENTIFIER,
    foreign_server_name information_schema.SQL_IDENTIFIER,
    foreign_data_wrapper_catalog information_schema.SQL_IDENTIFIER,
    foreign_data_wrapper_name information_schema.SQL_IDENTIFIER,
    foreign_server_type information_schema.CHARACTER_DATA,
    foreign_server_version information_schema.CHARACTER_DATA,
    authorization_identifier information_schema.SQL_IDENTIFIER
);
CREATE TABLE _pg_foreign_table_columns
(
    nspname NAME,
    relname NAME,
    attname NAME,
    attfdwoptions TEXT[]
);
CREATE TABLE _pg_foreign_tables
(
    foreign_table_catalog information_schema.SQL_IDENTIFIER,
    foreign_table_schema NAME,
    foreign_table_name NAME,
    ftoptions TEXT[],
    foreign_server_catalog information_schema.SQL_IDENTIFIER,
    foreign_server_name information_schema.SQL_IDENTIFIER,
    authorization_identifier information_schema.SQL_IDENTIFIER
);
CREATE TABLE _pg_user_mappings
(
    oid OID,
    umoptions TEXT[],
    umuser OID,
    authorization_identifier information_schema.SQL_IDENTIFIER,
    foreign_server_catalog information_schema.SQL_IDENTIFIER,
    foreign_server_name information_schema.SQL_IDENTIFIER,
    srvowner information_schema.SQL_IDENTIFIER
);
CREATE TABLE administrable_role_authorizations
(
    grantee information_schema.SQL_IDENTIFIER,
    role_name information_schema.SQL_IDENTIFIER,
    is_grantable information_schema.YES_OR_NO
);
CREATE TABLE applicable_roles
(
    grantee information_schema.SQL_IDENTIFIER,
    role_name information_schema.SQL_IDENTIFIER,
    is_grantable information_schema.YES_OR_NO
);
CREATE TABLE attributes
(
    udt_catalog information_schema.SQL_IDENTIFIER,
    udt_schema information_schema.SQL_IDENTIFIER,
    udt_name information_schema.SQL_IDENTIFIER,
    attribute_name information_schema.SQL_IDENTIFIER,
    ordinal_position information_schema.CARDINAL_NUMBER,
    attribute_default information_schema.CHARACTER_DATA,
    is_nullable information_schema.YES_OR_NO,
    data_type information_schema.CHARACTER_DATA,
    character_maximum_length information_schema.CARDINAL_NUMBER,
    character_octet_length information_schema.CARDINAL_NUMBER,
    character_set_catalog information_schema.SQL_IDENTIFIER,
    character_set_schema information_schema.SQL_IDENTIFIER,
    character_set_name information_schema.SQL_IDENTIFIER,
    collation_catalog information_schema.SQL_IDENTIFIER,
    collation_schema information_schema.SQL_IDENTIFIER,
    collation_name information_schema.SQL_IDENTIFIER,
    numeric_precision information_schema.CARDINAL_NUMBER,
    numeric_precision_radix information_schema.CARDINAL_NUMBER,
    numeric_scale information_schema.CARDINAL_NUMBER,
    datetime_precision information_schema.CARDINAL_NUMBER,
    interval_type information_schema.CHARACTER_DATA,
    interval_precision information_schema.CARDINAL_NUMBER,
    attribute_udt_catalog information_schema.SQL_IDENTIFIER,
    attribute_udt_schema information_schema.SQL_IDENTIFIER,
    attribute_udt_name information_schema.SQL_IDENTIFIER,
    scope_catalog information_schema.SQL_IDENTIFIER,
    scope_schema information_schema.SQL_IDENTIFIER,
    scope_name information_schema.SQL_IDENTIFIER,
    maximum_cardinality information_schema.CARDINAL_NUMBER,
    dtd_identifier information_schema.SQL_IDENTIFIER,
    is_derived_reference_attribute information_schema.YES_OR_NO
);
CREATE TABLE character_sets
(
    character_set_catalog information_schema.SQL_IDENTIFIER,
    character_set_schema information_schema.SQL_IDENTIFIER,
    character_set_name information_schema.SQL_IDENTIFIER,
    character_repertoire information_schema.SQL_IDENTIFIER,
    form_of_use information_schema.SQL_IDENTIFIER,
    default_collate_catalog information_schema.SQL_IDENTIFIER,
    default_collate_schema information_schema.SQL_IDENTIFIER,
    default_collate_name information_schema.SQL_IDENTIFIER
);
CREATE TABLE check_constraint_routine_usage
(
    constraint_catalog information_schema.SQL_IDENTIFIER,
    constraint_schema information_schema.SQL_IDENTIFIER,
    constraint_name information_schema.SQL_IDENTIFIER,
    specific_catalog information_schema.SQL_IDENTIFIER,
    specific_schema information_schema.SQL_IDENTIFIER,
    specific_name information_schema.SQL_IDENTIFIER
);
CREATE TABLE check_constraints
(
    constraint_catalog information_schema.SQL_IDENTIFIER,
    constraint_schema information_schema.SQL_IDENTIFIER,
    constraint_name information_schema.SQL_IDENTIFIER,
    check_clause information_schema.CHARACTER_DATA
);
CREATE TABLE collation_character_set_applicability
(
    collation_catalog information_schema.SQL_IDENTIFIER,
    collation_schema information_schema.SQL_IDENTIFIER,
    collation_name information_schema.SQL_IDENTIFIER,
    character_set_catalog information_schema.SQL_IDENTIFIER,
    character_set_schema information_schema.SQL_IDENTIFIER,
    character_set_name information_schema.SQL_IDENTIFIER
);
CREATE TABLE collations
(
    collation_catalog information_schema.SQL_IDENTIFIER,
    collation_schema information_schema.SQL_IDENTIFIER,
    collation_name information_schema.SQL_IDENTIFIER,
    pad_attribute information_schema.CHARACTER_DATA
);
CREATE TABLE column_domain_usage
(
    domain_catalog information_schema.SQL_IDENTIFIER,
    domain_schema information_schema.SQL_IDENTIFIER,
    domain_name information_schema.SQL_IDENTIFIER,
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER,
    column_name information_schema.SQL_IDENTIFIER
);
CREATE TABLE column_options
(
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema NAME,
    table_name NAME,
    column_name NAME,
    option_name information_schema.SQL_IDENTIFIER,
    option_value information_schema.CHARACTER_DATA
);
CREATE TABLE column_privileges
(
    grantor information_schema.SQL_IDENTIFIER,
    grantee information_schema.SQL_IDENTIFIER,
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER,
    column_name information_schema.SQL_IDENTIFIER,
    privilege_type information_schema.CHARACTER_DATA,
    is_grantable information_schema.YES_OR_NO
);
CREATE TABLE column_udt_usage
(
    udt_catalog information_schema.SQL_IDENTIFIER,
    udt_schema information_schema.SQL_IDENTIFIER,
    udt_name information_schema.SQL_IDENTIFIER,
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER,
    column_name information_schema.SQL_IDENTIFIER
);
CREATE TABLE columns
(
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER,
    column_name information_schema.SQL_IDENTIFIER,
    ordinal_position information_schema.CARDINAL_NUMBER,
    column_default information_schema.CHARACTER_DATA,
    is_nullable information_schema.YES_OR_NO,
    data_type information_schema.CHARACTER_DATA,
    character_maximum_length information_schema.CARDINAL_NUMBER,
    character_octet_length information_schema.CARDINAL_NUMBER,
    numeric_precision information_schema.CARDINAL_NUMBER,
    numeric_precision_radix information_schema.CARDINAL_NUMBER,
    numeric_scale information_schema.CARDINAL_NUMBER,
    datetime_precision information_schema.CARDINAL_NUMBER,
    interval_type information_schema.CHARACTER_DATA,
    interval_precision information_schema.CARDINAL_NUMBER,
    character_set_catalog information_schema.SQL_IDENTIFIER,
    character_set_schema information_schema.SQL_IDENTIFIER,
    character_set_name information_schema.SQL_IDENTIFIER,
    collation_catalog information_schema.SQL_IDENTIFIER,
    collation_schema information_schema.SQL_IDENTIFIER,
    collation_name information_schema.SQL_IDENTIFIER,
    domain_catalog information_schema.SQL_IDENTIFIER,
    domain_schema information_schema.SQL_IDENTIFIER,
    domain_name information_schema.SQL_IDENTIFIER,
    udt_catalog information_schema.SQL_IDENTIFIER,
    udt_schema information_schema.SQL_IDENTIFIER,
    udt_name information_schema.SQL_IDENTIFIER,
    scope_catalog information_schema.SQL_IDENTIFIER,
    scope_schema information_schema.SQL_IDENTIFIER,
    scope_name information_schema.SQL_IDENTIFIER,
    maximum_cardinality information_schema.CARDINAL_NUMBER,
    dtd_identifier information_schema.SQL_IDENTIFIER,
    is_self_referencing information_schema.YES_OR_NO,
    is_identity information_schema.YES_OR_NO,
    identity_generation information_schema.CHARACTER_DATA,
    identity_start information_schema.CHARACTER_DATA,
    identity_increment information_schema.CHARACTER_DATA,
    identity_maximum information_schema.CHARACTER_DATA,
    identity_minimum information_schema.CHARACTER_DATA,
    identity_cycle information_schema.YES_OR_NO,
    is_generated information_schema.CHARACTER_DATA,
    generation_expression information_schema.CHARACTER_DATA,
    is_updatable information_schema.YES_OR_NO
);
CREATE TABLE constraint_column_usage
(
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER,
    column_name information_schema.SQL_IDENTIFIER,
    constraint_catalog information_schema.SQL_IDENTIFIER,
    constraint_schema information_schema.SQL_IDENTIFIER,
    constraint_name information_schema.SQL_IDENTIFIER
);
CREATE TABLE constraint_table_usage
(
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER,
    constraint_catalog information_schema.SQL_IDENTIFIER,
    constraint_schema information_schema.SQL_IDENTIFIER,
    constraint_name information_schema.SQL_IDENTIFIER
);
CREATE TABLE data_type_privileges
(
    object_catalog information_schema.SQL_IDENTIFIER,
    object_schema information_schema.SQL_IDENTIFIER,
    object_name information_schema.SQL_IDENTIFIER,
    object_type information_schema.CHARACTER_DATA,
    dtd_identifier information_schema.SQL_IDENTIFIER
);
CREATE TABLE domain_constraints
(
    constraint_catalog information_schema.SQL_IDENTIFIER,
    constraint_schema information_schema.SQL_IDENTIFIER,
    constraint_name information_schema.SQL_IDENTIFIER,
    domain_catalog information_schema.SQL_IDENTIFIER,
    domain_schema information_schema.SQL_IDENTIFIER,
    domain_name information_schema.SQL_IDENTIFIER,
    is_deferrable information_schema.YES_OR_NO,
    initially_deferred information_schema.YES_OR_NO
);
CREATE TABLE domain_udt_usage
(
    udt_catalog information_schema.SQL_IDENTIFIER,
    udt_schema information_schema.SQL_IDENTIFIER,
    udt_name information_schema.SQL_IDENTIFIER,
    domain_catalog information_schema.SQL_IDENTIFIER,
    domain_schema information_schema.SQL_IDENTIFIER,
    domain_name information_schema.SQL_IDENTIFIER
);
CREATE TABLE domains
(
    domain_catalog information_schema.SQL_IDENTIFIER,
    domain_schema information_schema.SQL_IDENTIFIER,
    domain_name information_schema.SQL_IDENTIFIER,
    data_type information_schema.CHARACTER_DATA,
    character_maximum_length information_schema.CARDINAL_NUMBER,
    character_octet_length information_schema.CARDINAL_NUMBER,
    character_set_catalog information_schema.SQL_IDENTIFIER,
    character_set_schema information_schema.SQL_IDENTIFIER,
    character_set_name information_schema.SQL_IDENTIFIER,
    collation_catalog information_schema.SQL_IDENTIFIER,
    collation_schema information_schema.SQL_IDENTIFIER,
    collation_name information_schema.SQL_IDENTIFIER,
    numeric_precision information_schema.CARDINAL_NUMBER,
    numeric_precision_radix information_schema.CARDINAL_NUMBER,
    numeric_scale information_schema.CARDINAL_NUMBER,
    datetime_precision information_schema.CARDINAL_NUMBER,
    interval_type information_schema.CHARACTER_DATA,
    interval_precision information_schema.CARDINAL_NUMBER,
    domain_default information_schema.CHARACTER_DATA,
    udt_catalog information_schema.SQL_IDENTIFIER,
    udt_schema information_schema.SQL_IDENTIFIER,
    udt_name information_schema.SQL_IDENTIFIER,
    scope_catalog information_schema.SQL_IDENTIFIER,
    scope_schema information_schema.SQL_IDENTIFIER,
    scope_name information_schema.SQL_IDENTIFIER,
    maximum_cardinality information_schema.CARDINAL_NUMBER,
    dtd_identifier information_schema.SQL_IDENTIFIER
);
CREATE TABLE element_types
(
    object_catalog information_schema.SQL_IDENTIFIER,
    object_schema information_schema.SQL_IDENTIFIER,
    object_name information_schema.SQL_IDENTIFIER,
    object_type information_schema.CHARACTER_DATA,
    collection_type_identifier information_schema.SQL_IDENTIFIER,
    data_type information_schema.CHARACTER_DATA,
    character_maximum_length information_schema.CARDINAL_NUMBER,
    character_octet_length information_schema.CARDINAL_NUMBER,
    character_set_catalog information_schema.SQL_IDENTIFIER,
    character_set_schema information_schema.SQL_IDENTIFIER,
    character_set_name information_schema.SQL_IDENTIFIER,
    collation_catalog information_schema.SQL_IDENTIFIER,
    collation_schema information_schema.SQL_IDENTIFIER,
    collation_name information_schema.SQL_IDENTIFIER,
    numeric_precision information_schema.CARDINAL_NUMBER,
    numeric_precision_radix information_schema.CARDINAL_NUMBER,
    numeric_scale information_schema.CARDINAL_NUMBER,
    datetime_precision information_schema.CARDINAL_NUMBER,
    interval_type information_schema.CHARACTER_DATA,
    interval_precision information_schema.CARDINAL_NUMBER,
    domain_default information_schema.CHARACTER_DATA,
    udt_catalog information_schema.SQL_IDENTIFIER,
    udt_schema information_schema.SQL_IDENTIFIER,
    udt_name information_schema.SQL_IDENTIFIER,
    scope_catalog information_schema.SQL_IDENTIFIER,
    scope_schema information_schema.SQL_IDENTIFIER,
    scope_name information_schema.SQL_IDENTIFIER,
    maximum_cardinality information_schema.CARDINAL_NUMBER,
    dtd_identifier information_schema.SQL_IDENTIFIER
);
CREATE TABLE enabled_roles
(
    role_name information_schema.SQL_IDENTIFIER
);
CREATE TABLE foreign_data_wrapper_options
(
    foreign_data_wrapper_catalog information_schema.SQL_IDENTIFIER,
    foreign_data_wrapper_name information_schema.SQL_IDENTIFIER,
    option_name information_schema.SQL_IDENTIFIER,
    option_value information_schema.CHARACTER_DATA
);
CREATE TABLE foreign_data_wrappers
(
    foreign_data_wrapper_catalog information_schema.SQL_IDENTIFIER,
    foreign_data_wrapper_name information_schema.SQL_IDENTIFIER,
    authorization_identifier information_schema.SQL_IDENTIFIER,
    library_name information_schema.CHARACTER_DATA,
    foreign_data_wrapper_language information_schema.CHARACTER_DATA
);
CREATE TABLE foreign_server_options
(
    foreign_server_catalog information_schema.SQL_IDENTIFIER,
    foreign_server_name information_schema.SQL_IDENTIFIER,
    option_name information_schema.SQL_IDENTIFIER,
    option_value information_schema.CHARACTER_DATA
);
CREATE TABLE foreign_servers
(
    foreign_server_catalog information_schema.SQL_IDENTIFIER,
    foreign_server_name information_schema.SQL_IDENTIFIER,
    foreign_data_wrapper_catalog information_schema.SQL_IDENTIFIER,
    foreign_data_wrapper_name information_schema.SQL_IDENTIFIER,
    foreign_server_type information_schema.CHARACTER_DATA,
    foreign_server_version information_schema.CHARACTER_DATA,
    authorization_identifier information_schema.SQL_IDENTIFIER
);
CREATE TABLE foreign_table_options
(
    foreign_table_catalog information_schema.SQL_IDENTIFIER,
    foreign_table_schema NAME,
    foreign_table_name NAME,
    option_name information_schema.SQL_IDENTIFIER,
    option_value information_schema.CHARACTER_DATA
);
CREATE TABLE foreign_tables
(
    foreign_table_catalog information_schema.SQL_IDENTIFIER,
    foreign_table_schema NAME,
    foreign_table_name NAME,
    foreign_server_catalog information_schema.SQL_IDENTIFIER,
    foreign_server_name information_schema.SQL_IDENTIFIER
);
CREATE TABLE information_schema_catalog_name
(
    catalog_name information_schema.SQL_IDENTIFIER
);
CREATE TABLE key_column_usage
(
    constraint_catalog information_schema.SQL_IDENTIFIER,
    constraint_schema information_schema.SQL_IDENTIFIER,
    constraint_name information_schema.SQL_IDENTIFIER,
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER,
    column_name information_schema.SQL_IDENTIFIER,
    ordinal_position information_schema.CARDINAL_NUMBER,
    position_in_unique_constraint information_schema.CARDINAL_NUMBER
);
CREATE TABLE parameters
(
    specific_catalog information_schema.SQL_IDENTIFIER,
    specific_schema information_schema.SQL_IDENTIFIER,
    specific_name information_schema.SQL_IDENTIFIER,
    ordinal_position information_schema.CARDINAL_NUMBER,
    parameter_mode information_schema.CHARACTER_DATA,
    is_result information_schema.YES_OR_NO,
    as_locator information_schema.YES_OR_NO,
    parameter_name information_schema.SQL_IDENTIFIER,
    data_type information_schema.CHARACTER_DATA,
    character_maximum_length information_schema.CARDINAL_NUMBER,
    character_octet_length information_schema.CARDINAL_NUMBER,
    character_set_catalog information_schema.SQL_IDENTIFIER,
    character_set_schema information_schema.SQL_IDENTIFIER,
    character_set_name information_schema.SQL_IDENTIFIER,
    collation_catalog information_schema.SQL_IDENTIFIER,
    collation_schema information_schema.SQL_IDENTIFIER,
    collation_name information_schema.SQL_IDENTIFIER,
    numeric_precision information_schema.CARDINAL_NUMBER,
    numeric_precision_radix information_schema.CARDINAL_NUMBER,
    numeric_scale information_schema.CARDINAL_NUMBER,
    datetime_precision information_schema.CARDINAL_NUMBER,
    interval_type information_schema.CHARACTER_DATA,
    interval_precision information_schema.CARDINAL_NUMBER,
    udt_catalog information_schema.SQL_IDENTIFIER,
    udt_schema information_schema.SQL_IDENTIFIER,
    udt_name information_schema.SQL_IDENTIFIER,
    scope_catalog information_schema.SQL_IDENTIFIER,
    scope_schema information_schema.SQL_IDENTIFIER,
    scope_name information_schema.SQL_IDENTIFIER,
    maximum_cardinality information_schema.CARDINAL_NUMBER,
    dtd_identifier information_schema.SQL_IDENTIFIER,
    parameter_default information_schema.CHARACTER_DATA
);
CREATE TABLE referential_constraints
(
    constraint_catalog information_schema.SQL_IDENTIFIER,
    constraint_schema information_schema.SQL_IDENTIFIER,
    constraint_name information_schema.SQL_IDENTIFIER,
    unique_constraint_catalog information_schema.SQL_IDENTIFIER,
    unique_constraint_schema information_schema.SQL_IDENTIFIER,
    unique_constraint_name information_schema.SQL_IDENTIFIER,
    match_option information_schema.CHARACTER_DATA,
    update_rule information_schema.CHARACTER_DATA,
    delete_rule information_schema.CHARACTER_DATA
);
CREATE TABLE role_column_grants
(
    grantor information_schema.SQL_IDENTIFIER,
    grantee information_schema.SQL_IDENTIFIER,
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER,
    column_name information_schema.SQL_IDENTIFIER,
    privilege_type information_schema.CHARACTER_DATA,
    is_grantable information_schema.YES_OR_NO
);
CREATE TABLE role_routine_grants
(
    grantor information_schema.SQL_IDENTIFIER,
    grantee information_schema.SQL_IDENTIFIER,
    specific_catalog information_schema.SQL_IDENTIFIER,
    specific_schema information_schema.SQL_IDENTIFIER,
    specific_name information_schema.SQL_IDENTIFIER,
    routine_catalog information_schema.SQL_IDENTIFIER,
    routine_schema information_schema.SQL_IDENTIFIER,
    routine_name information_schema.SQL_IDENTIFIER,
    privilege_type information_schema.CHARACTER_DATA,
    is_grantable information_schema.YES_OR_NO
);
CREATE TABLE role_table_grants
(
    grantor information_schema.SQL_IDENTIFIER,
    grantee information_schema.SQL_IDENTIFIER,
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER,
    privilege_type information_schema.CHARACTER_DATA,
    is_grantable information_schema.YES_OR_NO,
    with_hierarchy information_schema.YES_OR_NO
);
CREATE TABLE role_udt_grants
(
    grantor information_schema.SQL_IDENTIFIER,
    grantee information_schema.SQL_IDENTIFIER,
    udt_catalog information_schema.SQL_IDENTIFIER,
    udt_schema information_schema.SQL_IDENTIFIER,
    udt_name information_schema.SQL_IDENTIFIER,
    privilege_type information_schema.CHARACTER_DATA,
    is_grantable information_schema.YES_OR_NO
);
CREATE TABLE role_usage_grants
(
    grantor information_schema.SQL_IDENTIFIER,
    grantee information_schema.SQL_IDENTIFIER,
    object_catalog information_schema.SQL_IDENTIFIER,
    object_schema information_schema.SQL_IDENTIFIER,
    object_name information_schema.SQL_IDENTIFIER,
    object_type information_schema.CHARACTER_DATA,
    privilege_type information_schema.CHARACTER_DATA,
    is_grantable information_schema.YES_OR_NO
);
CREATE TABLE routine_privileges
(
    grantor information_schema.SQL_IDENTIFIER,
    grantee information_schema.SQL_IDENTIFIER,
    specific_catalog information_schema.SQL_IDENTIFIER,
    specific_schema information_schema.SQL_IDENTIFIER,
    specific_name information_schema.SQL_IDENTIFIER,
    routine_catalog information_schema.SQL_IDENTIFIER,
    routine_schema information_schema.SQL_IDENTIFIER,
    routine_name information_schema.SQL_IDENTIFIER,
    privilege_type information_schema.CHARACTER_DATA,
    is_grantable information_schema.YES_OR_NO
);
CREATE TABLE routines
(
    specific_catalog information_schema.SQL_IDENTIFIER,
    specific_schema information_schema.SQL_IDENTIFIER,
    specific_name information_schema.SQL_IDENTIFIER,
    routine_catalog information_schema.SQL_IDENTIFIER,
    routine_schema information_schema.SQL_IDENTIFIER,
    routine_name information_schema.SQL_IDENTIFIER,
    routine_type information_schema.CHARACTER_DATA,
    module_catalog information_schema.SQL_IDENTIFIER,
    module_schema information_schema.SQL_IDENTIFIER,
    module_name information_schema.SQL_IDENTIFIER,
    udt_catalog information_schema.SQL_IDENTIFIER,
    udt_schema information_schema.SQL_IDENTIFIER,
    udt_name information_schema.SQL_IDENTIFIER,
    data_type information_schema.CHARACTER_DATA,
    character_maximum_length information_schema.CARDINAL_NUMBER,
    character_octet_length information_schema.CARDINAL_NUMBER,
    character_set_catalog information_schema.SQL_IDENTIFIER,
    character_set_schema information_schema.SQL_IDENTIFIER,
    character_set_name information_schema.SQL_IDENTIFIER,
    collation_catalog information_schema.SQL_IDENTIFIER,
    collation_schema information_schema.SQL_IDENTIFIER,
    collation_name information_schema.SQL_IDENTIFIER,
    numeric_precision information_schema.CARDINAL_NUMBER,
    numeric_precision_radix information_schema.CARDINAL_NUMBER,
    numeric_scale information_schema.CARDINAL_NUMBER,
    datetime_precision information_schema.CARDINAL_NUMBER,
    interval_type information_schema.CHARACTER_DATA,
    interval_precision information_schema.CARDINAL_NUMBER,
    type_udt_catalog information_schema.SQL_IDENTIFIER,
    type_udt_schema information_schema.SQL_IDENTIFIER,
    type_udt_name information_schema.SQL_IDENTIFIER,
    scope_catalog information_schema.SQL_IDENTIFIER,
    scope_schema information_schema.SQL_IDENTIFIER,
    scope_name information_schema.SQL_IDENTIFIER,
    maximum_cardinality information_schema.CARDINAL_NUMBER,
    dtd_identifier information_schema.SQL_IDENTIFIER,
    routine_body information_schema.CHARACTER_DATA,
    routine_definition information_schema.CHARACTER_DATA,
    external_name information_schema.CHARACTER_DATA,
    external_language information_schema.CHARACTER_DATA,
    parameter_style information_schema.CHARACTER_DATA,
    is_deterministic information_schema.YES_OR_NO,
    sql_data_access information_schema.CHARACTER_DATA,
    is_null_call information_schema.YES_OR_NO,
    sql_path information_schema.CHARACTER_DATA,
    schema_level_routine information_schema.YES_OR_NO,
    max_dynamic_result_sets information_schema.CARDINAL_NUMBER,
    is_user_defined_cast information_schema.YES_OR_NO,
    is_implicitly_invocable information_schema.YES_OR_NO,
    security_type information_schema.CHARACTER_DATA,
    to_sql_specific_catalog information_schema.SQL_IDENTIFIER,
    to_sql_specific_schema information_schema.SQL_IDENTIFIER,
    to_sql_specific_name information_schema.SQL_IDENTIFIER,
    as_locator information_schema.YES_OR_NO,
    created information_schema.TIME_STAMP,
    last_altered information_schema.TIME_STAMP,
    new_savepoint_level information_schema.YES_OR_NO,
    is_udt_dependent information_schema.YES_OR_NO,
    result_cast_from_data_type information_schema.CHARACTER_DATA,
    result_cast_as_locator information_schema.YES_OR_NO,
    result_cast_char_max_length information_schema.CARDINAL_NUMBER,
    result_cast_char_octet_length information_schema.CARDINAL_NUMBER,
    result_cast_char_set_catalog information_schema.SQL_IDENTIFIER,
    result_cast_char_set_schema information_schema.SQL_IDENTIFIER,
    result_cast_character_set_name information_schema.SQL_IDENTIFIER,
    result_cast_collation_catalog information_schema.SQL_IDENTIFIER,
    result_cast_collation_schema information_schema.SQL_IDENTIFIER,
    result_cast_collation_name information_schema.SQL_IDENTIFIER,
    result_cast_numeric_precision information_schema.CARDINAL_NUMBER,
    result_cast_numeric_precision_radix information_schema.CARDINAL_NUMBER,
    result_cast_numeric_scale information_schema.CARDINAL_NUMBER,
    result_cast_datetime_precision information_schema.CARDINAL_NUMBER,
    result_cast_interval_type information_schema.CHARACTER_DATA,
    result_cast_interval_precision information_schema.CARDINAL_NUMBER,
    result_cast_type_udt_catalog information_schema.SQL_IDENTIFIER,
    result_cast_type_udt_schema information_schema.SQL_IDENTIFIER,
    result_cast_type_udt_name information_schema.SQL_IDENTIFIER,
    result_cast_scope_catalog information_schema.SQL_IDENTIFIER,
    result_cast_scope_schema information_schema.SQL_IDENTIFIER,
    result_cast_scope_name information_schema.SQL_IDENTIFIER,
    result_cast_maximum_cardinality information_schema.CARDINAL_NUMBER,
    result_cast_dtd_identifier information_schema.SQL_IDENTIFIER
);
CREATE TABLE schemata
(
    catalog_name information_schema.SQL_IDENTIFIER,
    schema_name information_schema.SQL_IDENTIFIER,
    schema_owner information_schema.SQL_IDENTIFIER,
    default_character_set_catalog information_schema.SQL_IDENTIFIER,
    default_character_set_schema information_schema.SQL_IDENTIFIER,
    default_character_set_name information_schema.SQL_IDENTIFIER,
    sql_path information_schema.CHARACTER_DATA
);
CREATE TABLE sequences
(
    sequence_catalog information_schema.SQL_IDENTIFIER,
    sequence_schema information_schema.SQL_IDENTIFIER,
    sequence_name information_schema.SQL_IDENTIFIER,
    data_type information_schema.CHARACTER_DATA,
    numeric_precision information_schema.CARDINAL_NUMBER,
    numeric_precision_radix information_schema.CARDINAL_NUMBER,
    numeric_scale information_schema.CARDINAL_NUMBER,
    start_value information_schema.CHARACTER_DATA,
    minimum_value information_schema.CHARACTER_DATA,
    maximum_value information_schema.CHARACTER_DATA,
    increment information_schema.CHARACTER_DATA,
    cycle_option information_schema.YES_OR_NO
);
CREATE TABLE table_constraints
(
    constraint_catalog information_schema.SQL_IDENTIFIER,
    constraint_schema information_schema.SQL_IDENTIFIER,
    constraint_name information_schema.SQL_IDENTIFIER,
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER,
    constraint_type information_schema.CHARACTER_DATA,
    is_deferrable information_schema.YES_OR_NO,
    initially_deferred information_schema.YES_OR_NO
);
CREATE TABLE table_privileges
(
    grantor information_schema.SQL_IDENTIFIER,
    grantee information_schema.SQL_IDENTIFIER,
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER,
    privilege_type information_schema.CHARACTER_DATA,
    is_grantable information_schema.YES_OR_NO,
    with_hierarchy information_schema.YES_OR_NO
);
CREATE TABLE tables
(
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER,
    table_type information_schema.CHARACTER_DATA,
    self_referencing_column_name information_schema.SQL_IDENTIFIER,
    reference_generation information_schema.CHARACTER_DATA,
    user_defined_type_catalog information_schema.SQL_IDENTIFIER,
    user_defined_type_schema information_schema.SQL_IDENTIFIER,
    user_defined_type_name information_schema.SQL_IDENTIFIER,
    is_insertable_into information_schema.YES_OR_NO,
    is_typed information_schema.YES_OR_NO,
    commit_action information_schema.CHARACTER_DATA
);
CREATE TABLE transforms
(
    udt_catalog information_schema.SQL_IDENTIFIER,
    udt_schema information_schema.SQL_IDENTIFIER,
    udt_name information_schema.SQL_IDENTIFIER,
    specific_catalog information_schema.SQL_IDENTIFIER,
    specific_schema information_schema.SQL_IDENTIFIER,
    specific_name information_schema.SQL_IDENTIFIER,
    group_name information_schema.SQL_IDENTIFIER,
    transform_type information_schema.CHARACTER_DATA
);
CREATE TABLE triggered_update_columns
(
    trigger_catalog information_schema.SQL_IDENTIFIER,
    trigger_schema information_schema.SQL_IDENTIFIER,
    trigger_name information_schema.SQL_IDENTIFIER,
    event_object_catalog information_schema.SQL_IDENTIFIER,
    event_object_schema information_schema.SQL_IDENTIFIER,
    event_object_table information_schema.SQL_IDENTIFIER,
    event_object_column information_schema.SQL_IDENTIFIER
);
CREATE TABLE triggers
(
    trigger_catalog information_schema.SQL_IDENTIFIER,
    trigger_schema information_schema.SQL_IDENTIFIER,
    trigger_name information_schema.SQL_IDENTIFIER,
    event_manipulation information_schema.CHARACTER_DATA,
    event_object_catalog information_schema.SQL_IDENTIFIER,
    event_object_schema information_schema.SQL_IDENTIFIER,
    event_object_table information_schema.SQL_IDENTIFIER,
    action_order information_schema.CARDINAL_NUMBER,
    action_condition information_schema.CHARACTER_DATA,
    action_statement information_schema.CHARACTER_DATA,
    action_orientation information_schema.CHARACTER_DATA,
    action_timing information_schema.CHARACTER_DATA,
    action_reference_old_table information_schema.SQL_IDENTIFIER,
    action_reference_new_table information_schema.SQL_IDENTIFIER,
    action_reference_old_row information_schema.SQL_IDENTIFIER,
    action_reference_new_row information_schema.SQL_IDENTIFIER,
    created information_schema.TIME_STAMP
);
CREATE TABLE udt_privileges
(
    grantor information_schema.SQL_IDENTIFIER,
    grantee information_schema.SQL_IDENTIFIER,
    udt_catalog information_schema.SQL_IDENTIFIER,
    udt_schema information_schema.SQL_IDENTIFIER,
    udt_name information_schema.SQL_IDENTIFIER,
    privilege_type information_schema.CHARACTER_DATA,
    is_grantable information_schema.YES_OR_NO
);
CREATE TABLE usage_privileges
(
    grantor information_schema.SQL_IDENTIFIER,
    grantee information_schema.SQL_IDENTIFIER,
    object_catalog information_schema.SQL_IDENTIFIER,
    object_schema information_schema.SQL_IDENTIFIER,
    object_name information_schema.SQL_IDENTIFIER,
    object_type information_schema.CHARACTER_DATA,
    privilege_type information_schema.CHARACTER_DATA,
    is_grantable information_schema.YES_OR_NO
);
CREATE TABLE user_defined_types
(
    user_defined_type_catalog information_schema.SQL_IDENTIFIER,
    user_defined_type_schema information_schema.SQL_IDENTIFIER,
    user_defined_type_name information_schema.SQL_IDENTIFIER,
    user_defined_type_category information_schema.CHARACTER_DATA,
    is_instantiable information_schema.YES_OR_NO,
    is_final information_schema.YES_OR_NO,
    ordering_form information_schema.CHARACTER_DATA,
    ordering_category information_schema.CHARACTER_DATA,
    ordering_routine_catalog information_schema.SQL_IDENTIFIER,
    ordering_routine_schema information_schema.SQL_IDENTIFIER,
    ordering_routine_name information_schema.SQL_IDENTIFIER,
    reference_type information_schema.CHARACTER_DATA,
    data_type information_schema.CHARACTER_DATA,
    character_maximum_length information_schema.CARDINAL_NUMBER,
    character_octet_length information_schema.CARDINAL_NUMBER,
    character_set_catalog information_schema.SQL_IDENTIFIER,
    character_set_schema information_schema.SQL_IDENTIFIER,
    character_set_name information_schema.SQL_IDENTIFIER,
    collation_catalog information_schema.SQL_IDENTIFIER,
    collation_schema information_schema.SQL_IDENTIFIER,
    collation_name information_schema.SQL_IDENTIFIER,
    numeric_precision information_schema.CARDINAL_NUMBER,
    numeric_precision_radix information_schema.CARDINAL_NUMBER,
    numeric_scale information_schema.CARDINAL_NUMBER,
    datetime_precision information_schema.CARDINAL_NUMBER,
    interval_type information_schema.CHARACTER_DATA,
    interval_precision information_schema.CARDINAL_NUMBER,
    source_dtd_identifier information_schema.SQL_IDENTIFIER,
    ref_dtd_identifier information_schema.SQL_IDENTIFIER
);
CREATE TABLE user_mapping_options
(
    authorization_identifier information_schema.SQL_IDENTIFIER,
    foreign_server_catalog information_schema.SQL_IDENTIFIER,
    foreign_server_name information_schema.SQL_IDENTIFIER,
    option_name information_schema.SQL_IDENTIFIER,
    option_value information_schema.CHARACTER_DATA
);
CREATE TABLE user_mappings
(
    authorization_identifier information_schema.SQL_IDENTIFIER,
    foreign_server_catalog information_schema.SQL_IDENTIFIER,
    foreign_server_name information_schema.SQL_IDENTIFIER
);
CREATE TABLE view_column_usage
(
    view_catalog information_schema.SQL_IDENTIFIER,
    view_schema information_schema.SQL_IDENTIFIER,
    view_name information_schema.SQL_IDENTIFIER,
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER,
    column_name information_schema.SQL_IDENTIFIER
);
CREATE TABLE view_routine_usage
(
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER,
    specific_catalog information_schema.SQL_IDENTIFIER,
    specific_schema information_schema.SQL_IDENTIFIER,
    specific_name information_schema.SQL_IDENTIFIER
);
CREATE TABLE view_table_usage
(
    view_catalog information_schema.SQL_IDENTIFIER,
    view_schema information_schema.SQL_IDENTIFIER,
    view_name information_schema.SQL_IDENTIFIER,
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER
);
CREATE TABLE views
(
    table_catalog information_schema.SQL_IDENTIFIER,
    table_schema information_schema.SQL_IDENTIFIER,
    table_name information_schema.SQL_IDENTIFIER,
    view_definition information_schema.CHARACTER_DATA,
    check_option information_schema.CHARACTER_DATA,
    is_updatable information_schema.YES_OR_NO,
    is_insertable_into information_schema.YES_OR_NO,
    is_trigger_updatable information_schema.YES_OR_NO,
    is_trigger_deletable information_schema.YES_OR_NO,
    is_trigger_insertable_into information_schema.YES_OR_NO
);
CREATE FUNCTION _pg_char_max_length(typid OID, typmod INTEGER) RETURNS INTEGER;
CREATE FUNCTION _pg_char_octet_length(typid OID, typmod INTEGER) RETURNS INTEGER;
CREATE FUNCTION _pg_datetime_precision(typid OID, typmod INTEGER) RETURNS INTEGER;
CREATE FUNCTION _pg_expandarray(ANYARRAY, x OUT ANYELEMENT, n OUT INTEGER) RETURNS SETOF RECORD;
CREATE FUNCTION _pg_index_position(OID, SMALLINT) RETURNS INTEGER;
CREATE FUNCTION _pg_interval_type(typid OID, mod INTEGER) RETURNS TEXT;
CREATE FUNCTION _pg_keysequal(SMALLINT[], SMALLINT[]) RETURNS BOOLEAN;
CREATE FUNCTION _pg_numeric_precision(typid OID, typmod INTEGER) RETURNS INTEGER;
CREATE FUNCTION _pg_numeric_precision_radix(typid OID, typmod INTEGER) RETURNS INTEGER;
CREATE FUNCTION _pg_numeric_scale(typid OID, typmod INTEGER) RETURNS INTEGER;
CREATE FUNCTION _pg_truetypid(PG_ATTRIBUTE, PG_TYPE) RETURNS OID;
CREATE FUNCTION _pg_truetypmod(PG_ATTRIBUTE, PG_TYPE) RETURNS INTEGER;
