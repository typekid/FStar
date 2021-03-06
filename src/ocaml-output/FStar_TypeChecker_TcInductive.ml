open Prims
let (unfold_whnf :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  FStar_TypeChecker_Normalize.unfold_whnf'
    [FStar_TypeChecker_Env.AllowUnboundUniverses]
  
let (tc_tycon :
  FStar_TypeChecker_Env.env_t ->
    FStar_Syntax_Syntax.sigelt ->
      (FStar_TypeChecker_Env.env_t * FStar_Syntax_Syntax.sigelt *
        FStar_Syntax_Syntax.universe * FStar_TypeChecker_Common.guard_t))
  =
  fun env  ->
    fun s  ->
      match s.FStar_Syntax_Syntax.sigel with
      | FStar_Syntax_Syntax.Sig_inductive_typ (tc,uvs,tps,k,mutuals,data) ->
          let env0 = env  in
          let uu____50 = FStar_Syntax_Subst.univ_var_opening uvs  in
          (match uu____50 with
           | (usubst,uvs1) ->
               let uu____77 =
                 let uu____84 = FStar_TypeChecker_Env.push_univ_vars env uvs1
                    in
                 let uu____85 = FStar_Syntax_Subst.subst_binders usubst tps
                    in
                 let uu____86 =
                   let uu____87 =
                     FStar_Syntax_Subst.shift_subst (FStar_List.length tps)
                       usubst
                      in
                   FStar_Syntax_Subst.subst uu____87 k  in
                 (uu____84, uu____85, uu____86)  in
               (match uu____77 with
                | (env1,tps1,k1) ->
                    let uu____107 = FStar_Syntax_Subst.open_term tps1 k1  in
                    (match uu____107 with
                     | (tps2,k2) ->
                         let uu____122 =
                           FStar_TypeChecker_TcTerm.tc_binders env1 tps2  in
                         (match uu____122 with
                          | (tps3,env_tps,guard_params,us) ->
                              let uu____143 =
                                let uu____162 =
                                  FStar_TypeChecker_TcTerm.tc_tot_or_gtot_term
                                    env_tps k2
                                   in
                                match uu____162 with
                                | (k3,uu____188,g) ->
                                    let k4 =
                                      FStar_TypeChecker_Normalize.normalize
                                        [FStar_TypeChecker_Env.Exclude
                                           FStar_TypeChecker_Env.Iota;
                                        FStar_TypeChecker_Env.Exclude
                                          FStar_TypeChecker_Env.Zeta;
                                        FStar_TypeChecker_Env.Eager_unfolding;
                                        FStar_TypeChecker_Env.NoFullNorm;
                                        FStar_TypeChecker_Env.Exclude
                                          FStar_TypeChecker_Env.Beta] env_tps
                                        k3
                                       in
                                    let uu____191 =
                                      FStar_Syntax_Util.arrow_formals k4  in
                                    let uu____206 =
                                      let uu____207 =
                                        FStar_TypeChecker_Env.conj_guard
                                          guard_params g
                                         in
                                      FStar_TypeChecker_Rel.discharge_guard
                                        env_tps uu____207
                                       in
                                    (uu____191, uu____206)
                                 in
                              (match uu____143 with
                               | ((indices,t),guard) ->
                                   let k3 =
                                     let uu____270 =
                                       FStar_Syntax_Syntax.mk_Total t  in
                                     FStar_Syntax_Util.arrow indices
                                       uu____270
                                      in
                                   let uu____273 =
                                     FStar_Syntax_Util.type_u ()  in
                                   (match uu____273 with
                                    | (t_type,u) ->
                                        let valid_type =
                                          ((FStar_Syntax_Util.is_eqtype_no_unrefine
                                              t)
                                             &&
                                             (let uu____291 =
                                                FStar_All.pipe_right
                                                  s.FStar_Syntax_Syntax.sigquals
                                                  (FStar_List.contains
                                                     FStar_Syntax_Syntax.Unopteq)
                                                 in
                                              Prims.op_Negation uu____291))
                                            ||
                                            (FStar_TypeChecker_Rel.teq_nosmt_force
                                               env1 t t_type)
                                           in
                                        (if Prims.op_Negation valid_type
                                         then
                                           (let uu____298 =
                                              let uu____304 =
                                                let uu____306 =
                                                  FStar_Syntax_Print.term_to_string
                                                    t
                                                   in
                                                let uu____308 =
                                                  FStar_Ident.string_of_lid
                                                    tc
                                                   in
                                                FStar_Util.format2
                                                  "Type annotation %s for inductive %s is not Type or eqtype, or it is eqtype but contains unopteq qualifier"
                                                  uu____306 uu____308
                                                 in
                                              (FStar_Errors.Error_InductiveAnnotNotAType,
                                                uu____304)
                                               in
                                            FStar_Errors.raise_error
                                              uu____298
                                              s.FStar_Syntax_Syntax.sigrng)
                                         else ();
                                         (let usubst1 =
                                            FStar_Syntax_Subst.univ_var_closing
                                              uvs1
                                             in
                                          let guard1 =
                                            FStar_TypeChecker_Util.close_guard_implicits
                                              env1 false tps3 guard
                                             in
                                          let t_tc =
                                            let uu____322 =
                                              let uu____331 =
                                                FStar_All.pipe_right tps3
                                                  (FStar_Syntax_Subst.subst_binders
                                                     usubst1)
                                                 in
                                              let uu____348 =
                                                let uu____357 =
                                                  let uu____370 =
                                                    FStar_Syntax_Subst.shift_subst
                                                      (FStar_List.length tps3)
                                                      usubst1
                                                     in
                                                  FStar_Syntax_Subst.subst_binders
                                                    uu____370
                                                   in
                                                FStar_All.pipe_right indices
                                                  uu____357
                                                 in
                                              FStar_List.append uu____331
                                                uu____348
                                               in
                                            let uu____393 =
                                              let uu____396 =
                                                let uu____397 =
                                                  let uu____402 =
                                                    FStar_Syntax_Subst.shift_subst
                                                      ((FStar_List.length
                                                          tps3)
                                                         +
                                                         (FStar_List.length
                                                            indices)) usubst1
                                                     in
                                                  FStar_Syntax_Subst.subst
                                                    uu____402
                                                   in
                                                FStar_All.pipe_right t
                                                  uu____397
                                                 in
                                              FStar_Syntax_Syntax.mk_Total
                                                uu____396
                                               in
                                            FStar_Syntax_Util.arrow uu____322
                                              uu____393
                                             in
                                          let tps4 =
                                            FStar_Syntax_Subst.close_binders
                                              tps3
                                             in
                                          let k4 =
                                            FStar_Syntax_Subst.close tps4 k3
                                             in
                                          let uu____419 =
                                            let uu____424 =
                                              FStar_Syntax_Subst.subst_binders
                                                usubst1 tps4
                                               in
                                            let uu____425 =
                                              let uu____426 =
                                                FStar_Syntax_Subst.shift_subst
                                                  (FStar_List.length tps4)
                                                  usubst1
                                                 in
                                              FStar_Syntax_Subst.subst
                                                uu____426 k4
                                               in
                                            (uu____424, uu____425)  in
                                          match uu____419 with
                                          | (tps5,k5) ->
                                              let fv_tc =
                                                FStar_Syntax_Syntax.lid_as_fv
                                                  tc
                                                  FStar_Syntax_Syntax.delta_constant
                                                  FStar_Pervasives_Native.None
                                                 in
                                              let uu____446 =
                                                FStar_TypeChecker_Env.push_let_binding
                                                  env0 (FStar_Util.Inr fv_tc)
                                                  (uvs1, t_tc)
                                                 in
                                              (uu____446,
                                                (let uu___61_452 = s  in
                                                 {
                                                   FStar_Syntax_Syntax.sigel
                                                     =
                                                     (FStar_Syntax_Syntax.Sig_inductive_typ
                                                        (tc, uvs1, tps5, k5,
                                                          mutuals, data));
                                                   FStar_Syntax_Syntax.sigrng
                                                     =
                                                     (uu___61_452.FStar_Syntax_Syntax.sigrng);
                                                   FStar_Syntax_Syntax.sigquals
                                                     =
                                                     (uu___61_452.FStar_Syntax_Syntax.sigquals);
                                                   FStar_Syntax_Syntax.sigmeta
                                                     =
                                                     (uu___61_452.FStar_Syntax_Syntax.sigmeta);
                                                   FStar_Syntax_Syntax.sigattrs
                                                     =
                                                     (uu___61_452.FStar_Syntax_Syntax.sigattrs);
                                                   FStar_Syntax_Syntax.sigopts
                                                     =
                                                     (uu___61_452.FStar_Syntax_Syntax.sigopts)
                                                 }), u, guard1)))))))))
      | uu____457 -> failwith "impossible"
  
let (tc_data :
  FStar_TypeChecker_Env.env_t ->
    (FStar_Syntax_Syntax.sigelt * FStar_Syntax_Syntax.universe) Prims.list ->
      FStar_Syntax_Syntax.sigelt ->
        (FStar_Syntax_Syntax.sigelt * FStar_TypeChecker_Common.guard_t))
  =
  fun env  ->
    fun tcs  ->
      fun se  ->
        match se.FStar_Syntax_Syntax.sigel with
        | FStar_Syntax_Syntax.Sig_datacon (c,_uvs,t,tc_lid,ntps,_mutual_tcs)
            ->
            let uu____521 = FStar_Syntax_Subst.univ_var_opening _uvs  in
            (match uu____521 with
             | (usubst,_uvs1) ->
                 let uu____544 =
                   let uu____549 =
                     FStar_TypeChecker_Env.push_univ_vars env _uvs1  in
                   let uu____550 = FStar_Syntax_Subst.subst usubst t  in
                   (uu____549, uu____550)  in
                 (match uu____544 with
                  | (env1,t1) ->
                      let uu____557 =
                        let tps_u_opt =
                          FStar_Util.find_map tcs
                            (fun uu____596  ->
                               match uu____596 with
                               | (se1,u_tc) ->
                                   let uu____611 =
                                     let uu____613 =
                                       let uu____614 =
                                         FStar_Syntax_Util.lid_of_sigelt se1
                                          in
                                       FStar_Util.must uu____614  in
                                     FStar_Ident.lid_equals tc_lid uu____613
                                      in
                                   if uu____611
                                   then
                                     (match se1.FStar_Syntax_Syntax.sigel
                                      with
                                      | FStar_Syntax_Syntax.Sig_inductive_typ
                                          (uu____634,uu____635,tps,uu____637,uu____638,uu____639)
                                          ->
                                          let tps1 =
                                            let uu____649 =
                                              FStar_All.pipe_right tps
                                                (FStar_Syntax_Subst.subst_binders
                                                   usubst)
                                               in
                                            FStar_All.pipe_right uu____649
                                              (FStar_List.map
                                                 (fun uu____689  ->
                                                    match uu____689 with
                                                    | (x,uu____703) ->
                                                        (x,
                                                          (FStar_Pervasives_Native.Some
                                                             FStar_Syntax_Syntax.imp_tag))))
                                             in
                                          let tps2 =
                                            FStar_Syntax_Subst.open_binders
                                              tps1
                                             in
                                          let uu____711 =
                                            let uu____718 =
                                              FStar_TypeChecker_Env.push_binders
                                                env1 tps2
                                               in
                                            (uu____718, tps2, u_tc)  in
                                          FStar_Pervasives_Native.Some
                                            uu____711
                                      | uu____725 -> failwith "Impossible")
                                   else FStar_Pervasives_Native.None)
                           in
                        match tps_u_opt with
                        | FStar_Pervasives_Native.Some x -> x
                        | FStar_Pervasives_Native.None  ->
                            let uu____768 =
                              FStar_Ident.lid_equals tc_lid
                                FStar_Parser_Const.exn_lid
                               in
                            if uu____768
                            then (env1, [], FStar_Syntax_Syntax.U_zero)
                            else
                              FStar_Errors.raise_error
                                (FStar_Errors.Fatal_UnexpectedDataConstructor,
                                  "Unexpected data constructor")
                                se.FStar_Syntax_Syntax.sigrng
                         in
                      (match uu____557 with
                       | (env2,tps,u_tc) ->
                           let uu____800 =
                             let t2 =
                               FStar_TypeChecker_Normalize.normalize
                                 (FStar_List.append
                                    FStar_TypeChecker_Normalize.whnf_steps
                                    [FStar_TypeChecker_Env.AllowUnboundUniverses])
                                 env2 t1
                                in
                             let uu____808 =
                               let uu____809 = FStar_Syntax_Subst.compress t2
                                  in
                               uu____809.FStar_Syntax_Syntax.n  in
                             match uu____808 with
                             | FStar_Syntax_Syntax.Tm_arrow (bs,res) ->
                                 let uu____840 = FStar_Util.first_N ntps bs
                                    in
                                 (match uu____840 with
                                  | (uu____873,bs') ->
                                      let t3 =
                                        FStar_Syntax_Syntax.mk
                                          (FStar_Syntax_Syntax.Tm_arrow
                                             (bs', res))
                                          FStar_Pervasives_Native.None
                                          t2.FStar_Syntax_Syntax.pos
                                         in
                                      let subst =
                                        FStar_All.pipe_right tps
                                          (FStar_List.mapi
                                             (fun i  ->
                                                fun uu____944  ->
                                                  match uu____944 with
                                                  | (x,uu____953) ->
                                                      FStar_Syntax_Syntax.DB
                                                        ((ntps -
                                                            (Prims.int_one +
                                                               i)), x)))
                                         in
                                      let uu____960 =
                                        let uu____965 =
                                          FStar_Syntax_Subst.subst subst t3
                                           in
                                        FStar_Syntax_Util.arrow_formals_comp
                                          uu____965
                                         in
                                      (match uu____960 with
                                       | (bs1,c1) ->
                                           let uu____974 =
                                             (FStar_Options.ml_ish ()) ||
                                               (FStar_Syntax_Util.is_total_comp
                                                  c1)
                                              in
                                           if uu____974
                                           then
                                             (bs1,
                                               (FStar_Syntax_Util.comp_result
                                                  c1))
                                           else
                                             (let uu____987 =
                                                FStar_Ident.range_of_lid
                                                  (FStar_Syntax_Util.comp_effect_name
                                                     c1)
                                                 in
                                              FStar_Errors.raise_error
                                                (FStar_Errors.Fatal_UnexpectedConstructorType,
                                                  "Constructors cannot have effects")
                                                uu____987)))
                             | uu____996 -> ([], t2)  in
                           (match uu____800 with
                            | (arguments,result) ->
                                ((let uu____1016 =
                                    FStar_TypeChecker_Env.debug env2
                                      FStar_Options.Low
                                     in
                                  if uu____1016
                                  then
                                    let uu____1019 =
                                      FStar_Syntax_Print.lid_to_string c  in
                                    let uu____1021 =
                                      FStar_Syntax_Print.binders_to_string
                                        "->" arguments
                                       in
                                    let uu____1024 =
                                      FStar_Syntax_Print.term_to_string
                                        result
                                       in
                                    FStar_Util.print3
                                      "Checking datacon  %s : %s -> %s \n"
                                      uu____1019 uu____1021 uu____1024
                                  else ());
                                 (let uu____1029 =
                                    FStar_TypeChecker_TcTerm.tc_tparams env2
                                      arguments
                                     in
                                  match uu____1029 with
                                  | (arguments1,env',us) ->
                                      let type_u_tc =
                                        FStar_Syntax_Syntax.mk
                                          (FStar_Syntax_Syntax.Tm_type u_tc)
                                          FStar_Pervasives_Native.None
                                          result.FStar_Syntax_Syntax.pos
                                         in
                                      let env'1 =
                                        FStar_TypeChecker_Env.set_expected_typ
                                          env' type_u_tc
                                         in
                                      let uu____1047 =
                                        FStar_TypeChecker_TcTerm.tc_trivial_guard
                                          env'1 result
                                         in
                                      (match uu____1047 with
                                       | (result1,res_lcomp) ->
                                           let uu____1058 =
                                             FStar_Syntax_Util.head_and_args
                                               result1
                                              in
                                           (match uu____1058 with
                                            | (head,args) ->
                                                let p_args =
                                                  let uu____1116 =
                                                    FStar_Util.first_N
                                                      (FStar_List.length tps)
                                                      args
                                                     in
                                                  FStar_Pervasives_Native.fst
                                                    uu____1116
                                                   in
                                                (FStar_List.iter2
                                                   (fun uu____1198  ->
                                                      fun uu____1199  ->
                                                        match (uu____1198,
                                                                uu____1199)
                                                        with
                                                        | ((bv,uu____1229),
                                                           (t2,uu____1231))
                                                            ->
                                                            let uu____1258 =
                                                              let uu____1259
                                                                =
                                                                FStar_Syntax_Subst.compress
                                                                  t2
                                                                 in
                                                              uu____1259.FStar_Syntax_Syntax.n
                                                               in
                                                            (match uu____1258
                                                             with
                                                             | FStar_Syntax_Syntax.Tm_name
                                                                 bv' when
                                                                 FStar_Syntax_Syntax.bv_eq
                                                                   bv bv'
                                                                 -> ()
                                                             | uu____1263 ->
                                                                 let uu____1264
                                                                   =
                                                                   let uu____1270
                                                                    =
                                                                    let uu____1272
                                                                    =
                                                                    FStar_Syntax_Print.bv_to_string
                                                                    bv  in
                                                                    let uu____1274
                                                                    =
                                                                    FStar_Syntax_Print.term_to_string
                                                                    t2  in
                                                                    FStar_Util.format2
                                                                    "This parameter is not constant: expected %s, got %s"
                                                                    uu____1272
                                                                    uu____1274
                                                                     in
                                                                   (FStar_Errors.Error_BadInductiveParam,
                                                                    uu____1270)
                                                                    in
                                                                 FStar_Errors.raise_error
                                                                   uu____1264
                                                                   t2.FStar_Syntax_Syntax.pos))
                                                   tps p_args;
                                                 (let ty =
                                                    let uu____1279 =
                                                      unfold_whnf env2
                                                        res_lcomp.FStar_TypeChecker_Common.res_typ
                                                       in
                                                    FStar_All.pipe_right
                                                      uu____1279
                                                      FStar_Syntax_Util.unrefine
                                                     in
                                                  (let uu____1281 =
                                                     let uu____1282 =
                                                       FStar_Syntax_Subst.compress
                                                         ty
                                                        in
                                                     uu____1282.FStar_Syntax_Syntax.n
                                                      in
                                                   match uu____1281 with
                                                   | FStar_Syntax_Syntax.Tm_type
                                                       uu____1285 -> ()
                                                   | uu____1286 ->
                                                       let uu____1287 =
                                                         let uu____1293 =
                                                           let uu____1295 =
                                                             FStar_Syntax_Print.term_to_string
                                                               result1
                                                              in
                                                           let uu____1297 =
                                                             FStar_Syntax_Print.term_to_string
                                                               ty
                                                              in
                                                           FStar_Util.format2
                                                             "The type of %s is %s, but since this is the result type of a constructor its type should be Type"
                                                             uu____1295
                                                             uu____1297
                                                            in
                                                         (FStar_Errors.Fatal_WrongResultTypeAfterConstrutor,
                                                           uu____1293)
                                                          in
                                                       FStar_Errors.raise_error
                                                         uu____1287
                                                         se.FStar_Syntax_Syntax.sigrng);
                                                  (let g_uvs =
                                                     let uu____1302 =
                                                       let uu____1303 =
                                                         FStar_Syntax_Subst.compress
                                                           head
                                                          in
                                                       uu____1303.FStar_Syntax_Syntax.n
                                                        in
                                                     match uu____1302 with
                                                     | FStar_Syntax_Syntax.Tm_uinst
                                                         ({
                                                            FStar_Syntax_Syntax.n
                                                              =
                                                              FStar_Syntax_Syntax.Tm_fvar
                                                              fv;
                                                            FStar_Syntax_Syntax.pos
                                                              = uu____1307;
                                                            FStar_Syntax_Syntax.vars
                                                              = uu____1308;_},tuvs)
                                                         when
                                                         FStar_Syntax_Syntax.fv_eq_lid
                                                           fv tc_lid
                                                         ->
                                                         if
                                                           (FStar_List.length
                                                              _uvs1)
                                                             =
                                                             (FStar_List.length
                                                                tuvs)
                                                         then
                                                           FStar_List.fold_left2
                                                             (fun g  ->
                                                                fun u1  ->
                                                                  fun u2  ->
                                                                    let uu____1322
                                                                    =
                                                                    let uu____1323
                                                                    =
                                                                    FStar_Syntax_Syntax.mk
                                                                    (FStar_Syntax_Syntax.Tm_type
                                                                    u1)
                                                                    FStar_Pervasives_Native.None
                                                                    FStar_Range.dummyRange
                                                                     in
                                                                    let uu____1324
                                                                    =
                                                                    FStar_Syntax_Syntax.mk
                                                                    (FStar_Syntax_Syntax.Tm_type
                                                                    (FStar_Syntax_Syntax.U_name
                                                                    u2))
                                                                    FStar_Pervasives_Native.None
                                                                    FStar_Range.dummyRange
                                                                     in
                                                                    FStar_TypeChecker_Rel.teq
                                                                    env'1
                                                                    uu____1323
                                                                    uu____1324
                                                                     in
                                                                    FStar_TypeChecker_Env.conj_guard
                                                                    g
                                                                    uu____1322)
                                                             FStar_TypeChecker_Env.trivial_guard
                                                             tuvs _uvs1
                                                         else
                                                           FStar_Errors.raise_error
                                                             (FStar_Errors.Fatal_UnexpectedConstructorType,
                                                               "Length of annotated universes does not match inferred universes")
                                                             se.FStar_Syntax_Syntax.sigrng
                                                     | FStar_Syntax_Syntax.Tm_fvar
                                                         fv when
                                                         FStar_Syntax_Syntax.fv_eq_lid
                                                           fv tc_lid
                                                         ->
                                                         FStar_TypeChecker_Env.trivial_guard
                                                     | uu____1330 ->
                                                         let uu____1331 =
                                                           let uu____1337 =
                                                             let uu____1339 =
                                                               FStar_Syntax_Print.lid_to_string
                                                                 tc_lid
                                                                in
                                                             let uu____1341 =
                                                               FStar_Syntax_Print.term_to_string
                                                                 head
                                                                in
                                                             FStar_Util.format2
                                                               "Expected a constructor of type %s; got %s"
                                                               uu____1339
                                                               uu____1341
                                                              in
                                                           (FStar_Errors.Fatal_UnexpectedConstructorType,
                                                             uu____1337)
                                                            in
                                                         FStar_Errors.raise_error
                                                           uu____1331
                                                           se.FStar_Syntax_Syntax.sigrng
                                                      in
                                                   let g =
                                                     FStar_List.fold_left2
                                                       (fun g  ->
                                                          fun uu____1359  ->
                                                            fun u_x  ->
                                                              match uu____1359
                                                              with
                                                              | (x,uu____1368)
                                                                  ->
                                                                  let uu____1373
                                                                    =
                                                                    FStar_TypeChecker_Rel.universe_inequality
                                                                    u_x u_tc
                                                                     in
                                                                  FStar_TypeChecker_Env.conj_guard
                                                                    g
                                                                    uu____1373)
                                                       g_uvs arguments1 us
                                                      in
                                                   let t2 =
                                                     let uu____1377 =
                                                       let uu____1386 =
                                                         FStar_All.pipe_right
                                                           tps
                                                           (FStar_List.map
                                                              (fun uu____1426
                                                                  ->
                                                                 match uu____1426
                                                                 with
                                                                 | (x,uu____1440)
                                                                    ->
                                                                    (x,
                                                                    (FStar_Pervasives_Native.Some
                                                                    (FStar_Syntax_Syntax.Implicit
                                                                    true)))))
                                                          in
                                                       FStar_List.append
                                                         uu____1386
                                                         arguments1
                                                        in
                                                     let uu____1454 =
                                                       FStar_Syntax_Syntax.mk_Total
                                                         result1
                                                        in
                                                     FStar_Syntax_Util.arrow
                                                       uu____1377 uu____1454
                                                      in
                                                   let t3 =
                                                     FStar_Syntax_Subst.close_univ_vars
                                                       _uvs1 t2
                                                      in
                                                   ((let uu___187_1459 = se
                                                        in
                                                     {
                                                       FStar_Syntax_Syntax.sigel
                                                         =
                                                         (FStar_Syntax_Syntax.Sig_datacon
                                                            (c, _uvs1, t3,
                                                              tc_lid, ntps,
                                                              []));
                                                       FStar_Syntax_Syntax.sigrng
                                                         =
                                                         (uu___187_1459.FStar_Syntax_Syntax.sigrng);
                                                       FStar_Syntax_Syntax.sigquals
                                                         =
                                                         (uu___187_1459.FStar_Syntax_Syntax.sigquals);
                                                       FStar_Syntax_Syntax.sigmeta
                                                         =
                                                         (uu___187_1459.FStar_Syntax_Syntax.sigmeta);
                                                       FStar_Syntax_Syntax.sigattrs
                                                         =
                                                         (uu___187_1459.FStar_Syntax_Syntax.sigattrs);
                                                       FStar_Syntax_Syntax.sigopts
                                                         =
                                                         (uu___187_1459.FStar_Syntax_Syntax.sigopts)
                                                     }), g))))))))))))
        | uu____1463 -> failwith "impossible"
  
let (generalize_and_inst_within :
  FStar_TypeChecker_Env.env_t ->
    (FStar_Syntax_Syntax.sigelt * FStar_Syntax_Syntax.universe) Prims.list ->
      FStar_Syntax_Syntax.sigelt Prims.list ->
        (FStar_Syntax_Syntax.sigelt Prims.list * FStar_Syntax_Syntax.sigelt
          Prims.list))
  =
  fun env  ->
    fun tcs  ->
      fun datas  ->
        let binders =
          FStar_All.pipe_right tcs
            (FStar_List.map
               (fun uu____1554  ->
                  match uu____1554 with
                  | (se,uu____1560) ->
                      (match se.FStar_Syntax_Syntax.sigel with
                       | FStar_Syntax_Syntax.Sig_inductive_typ
                           (uu____1561,uu____1562,tps,k,uu____1565,uu____1566)
                           ->
                           let uu____1575 =
                             let uu____1576 = FStar_Syntax_Syntax.mk_Total k
                                in
                             FStar_All.pipe_left
                               (FStar_Syntax_Util.arrow tps) uu____1576
                              in
                           FStar_Syntax_Syntax.null_binder uu____1575
                       | uu____1581 -> failwith "Impossible")))
           in
        let binders' =
          FStar_All.pipe_right datas
            (FStar_List.map
               (fun se  ->
                  match se.FStar_Syntax_Syntax.sigel with
                  | FStar_Syntax_Syntax.Sig_datacon
                      (uu____1610,uu____1611,t,uu____1613,uu____1614,uu____1615)
                      -> FStar_Syntax_Syntax.null_binder t
                  | uu____1622 -> failwith "Impossible"))
           in
        let t =
          let uu____1627 =
            FStar_Syntax_Syntax.mk_Total FStar_Syntax_Syntax.t_unit  in
          FStar_Syntax_Util.arrow (FStar_List.append binders binders')
            uu____1627
           in
        (let uu____1637 =
           FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
             (FStar_Options.Other "GenUniverses")
            in
         if uu____1637
         then
           let uu____1642 = FStar_TypeChecker_Normalize.term_to_string env t
              in
           FStar_Util.print1 "@@@@@@Trying to generalize universes in %s\n"
             uu____1642
         else ());
        (let uu____1647 = FStar_TypeChecker_Util.generalize_universes env t
            in
         match uu____1647 with
         | (uvs,t1) ->
             ((let uu____1667 =
                 FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                   (FStar_Options.Other "GenUniverses")
                  in
               if uu____1667
               then
                 let uu____1672 =
                   let uu____1674 =
                     FStar_All.pipe_right uvs
                       (FStar_List.map (fun u  -> FStar_Ident.text_of_id u))
                      in
                   FStar_All.pipe_right uu____1674 (FStar_String.concat ", ")
                    in
                 let uu____1691 = FStar_Syntax_Print.term_to_string t1  in
                 FStar_Util.print2 "@@@@@@Generalized to (%s, %s)\n"
                   uu____1672 uu____1691
               else ());
              (let uu____1696 = FStar_Syntax_Subst.open_univ_vars uvs t1  in
               match uu____1696 with
               | (uvs1,t2) ->
                   let uu____1711 = FStar_Syntax_Util.arrow_formals t2  in
                   (match uu____1711 with
                    | (args,uu____1727) ->
                        let uu____1732 =
                          FStar_Util.first_N (FStar_List.length binders) args
                           in
                        (match uu____1732 with
                         | (tc_types,data_types) ->
                             let tcs1 =
                               FStar_List.map2
                                 (fun uu____1837  ->
                                    fun uu____1838  ->
                                      match (uu____1837, uu____1838) with
                                      | ((x,uu____1860),(se,uu____1862)) ->
                                          (match se.FStar_Syntax_Syntax.sigel
                                           with
                                           | FStar_Syntax_Syntax.Sig_inductive_typ
                                               (tc,uu____1878,tps,uu____1880,mutuals,datas1)
                                               ->
                                               let ty =
                                                 FStar_Syntax_Subst.close_univ_vars
                                                   uvs1
                                                   x.FStar_Syntax_Syntax.sort
                                                  in
                                               let uu____1892 =
                                                 let uu____1897 =
                                                   let uu____1898 =
                                                     FStar_Syntax_Subst.compress
                                                       ty
                                                      in
                                                   uu____1898.FStar_Syntax_Syntax.n
                                                    in
                                                 match uu____1897 with
                                                 | FStar_Syntax_Syntax.Tm_arrow
                                                     (binders1,c) ->
                                                     let uu____1927 =
                                                       FStar_Util.first_N
                                                         (FStar_List.length
                                                            tps) binders1
                                                        in
                                                     (match uu____1927 with
                                                      | (tps1,rest) ->
                                                          let t3 =
                                                            match rest with
                                                            | [] ->
                                                                FStar_Syntax_Util.comp_result
                                                                  c
                                                            | uu____2005 ->
                                                                FStar_Syntax_Syntax.mk
                                                                  (FStar_Syntax_Syntax.Tm_arrow
                                                                    (rest, c))
                                                                  FStar_Pervasives_Native.None
                                                                  (x.FStar_Syntax_Syntax.sort).FStar_Syntax_Syntax.pos
                                                             in
                                                          (tps1, t3))
                                                 | uu____2024 -> ([], ty)  in
                                               (match uu____1892 with
                                                | (tps1,t3) ->
                                                    let uu___264_2033 = se
                                                       in
                                                    {
                                                      FStar_Syntax_Syntax.sigel
                                                        =
                                                        (FStar_Syntax_Syntax.Sig_inductive_typ
                                                           (tc, uvs1, tps1,
                                                             t3, mutuals,
                                                             datas1));
                                                      FStar_Syntax_Syntax.sigrng
                                                        =
                                                        (uu___264_2033.FStar_Syntax_Syntax.sigrng);
                                                      FStar_Syntax_Syntax.sigquals
                                                        =
                                                        (uu___264_2033.FStar_Syntax_Syntax.sigquals);
                                                      FStar_Syntax_Syntax.sigmeta
                                                        =
                                                        (uu___264_2033.FStar_Syntax_Syntax.sigmeta);
                                                      FStar_Syntax_Syntax.sigattrs
                                                        =
                                                        (uu___264_2033.FStar_Syntax_Syntax.sigattrs);
                                                      FStar_Syntax_Syntax.sigopts
                                                        =
                                                        (uu___264_2033.FStar_Syntax_Syntax.sigopts)
                                                    })
                                           | uu____2038 ->
                                               failwith "Impossible"))
                                 tc_types tcs
                                in
                             let datas1 =
                               match uvs1 with
                               | [] -> datas
                               | uu____2045 ->
                                   let uvs_universes =
                                     FStar_All.pipe_right uvs1
                                       (FStar_List.map
                                          (fun uu____2049  ->
                                             FStar_Syntax_Syntax.U_name
                                               uu____2049))
                                      in
                                   let tc_insts =
                                     FStar_All.pipe_right tcs1
                                       (FStar_List.map
                                          (fun uu___0_2069  ->
                                             match uu___0_2069 with
                                             | {
                                                 FStar_Syntax_Syntax.sigel =
                                                   FStar_Syntax_Syntax.Sig_inductive_typ
                                                   (tc,uu____2075,uu____2076,uu____2077,uu____2078,uu____2079);
                                                 FStar_Syntax_Syntax.sigrng =
                                                   uu____2080;
                                                 FStar_Syntax_Syntax.sigquals
                                                   = uu____2081;
                                                 FStar_Syntax_Syntax.sigmeta
                                                   = uu____2082;
                                                 FStar_Syntax_Syntax.sigattrs
                                                   = uu____2083;
                                                 FStar_Syntax_Syntax.sigopts
                                                   = uu____2084;_}
                                                 -> (tc, uvs_universes)
                                             | uu____2099 ->
                                                 failwith "Impossible"))
                                      in
                                   FStar_List.map2
                                     (fun uu____2123  ->
                                        fun d  ->
                                          match uu____2123 with
                                          | (t3,uu____2132) ->
                                              (match d.FStar_Syntax_Syntax.sigel
                                               with
                                               | FStar_Syntax_Syntax.Sig_datacon
                                                   (l,uu____2138,uu____2139,tc,ntps,mutuals)
                                                   ->
                                                   let ty =
                                                     let uu____2150 =
                                                       FStar_Syntax_InstFV.instantiate
                                                         tc_insts
                                                         t3.FStar_Syntax_Syntax.sort
                                                        in
                                                     FStar_All.pipe_right
                                                       uu____2150
                                                       (FStar_Syntax_Subst.close_univ_vars
                                                          uvs1)
                                                      in
                                                   let uu___301_2151 = d  in
                                                   {
                                                     FStar_Syntax_Syntax.sigel
                                                       =
                                                       (FStar_Syntax_Syntax.Sig_datacon
                                                          (l, uvs1, ty, tc,
                                                            ntps, mutuals));
                                                     FStar_Syntax_Syntax.sigrng
                                                       =
                                                       (uu___301_2151.FStar_Syntax_Syntax.sigrng);
                                                     FStar_Syntax_Syntax.sigquals
                                                       =
                                                       (uu___301_2151.FStar_Syntax_Syntax.sigquals);
                                                     FStar_Syntax_Syntax.sigmeta
                                                       =
                                                       (uu___301_2151.FStar_Syntax_Syntax.sigmeta);
                                                     FStar_Syntax_Syntax.sigattrs
                                                       =
                                                       (uu___301_2151.FStar_Syntax_Syntax.sigattrs);
                                                     FStar_Syntax_Syntax.sigopts
                                                       =
                                                       (uu___301_2151.FStar_Syntax_Syntax.sigopts)
                                                   }
                                               | uu____2155 ->
                                                   failwith "Impossible"))
                                     data_types datas
                                in
                             (tcs1, datas1))))))
  
let (debug_log :
  FStar_TypeChecker_Env.env_t -> (unit -> Prims.string) -> unit) =
  fun env  ->
    fun msg  ->
      let uu____2179 =
        FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
          (FStar_Options.Other "Positivity")
         in
      if uu____2179
      then
        let uu____2184 =
          let uu____2186 =
            let uu____2188 = msg ()  in Prims.op_Hat uu____2188 "\n"  in
          Prims.op_Hat "Positivity::" uu____2186  in
        FStar_Util.print_string uu____2184
      else ()
  
let (ty_occurs_in :
  FStar_Ident.lident -> FStar_Syntax_Syntax.term -> Prims.bool) =
  fun ty_lid  ->
    fun t  ->
      let uu____2207 = FStar_Syntax_Free.fvars t  in
      FStar_Util.set_mem ty_lid uu____2207
  
let rec (try_get_fv :
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.fv * FStar_Syntax_Syntax.universes)
      FStar_Pervasives_Native.option)
  =
  fun t  ->
    let uu____2228 =
      let uu____2229 = FStar_Syntax_Subst.compress t  in
      uu____2229.FStar_Syntax_Syntax.n  in
    match uu____2228 with
    | FStar_Syntax_Syntax.Tm_name uu____2238 -> FStar_Pervasives_Native.None
    | FStar_Syntax_Syntax.Tm_fvar fv -> FStar_Pervasives_Native.Some (fv, [])
    | FStar_Syntax_Syntax.Tm_uinst (t1,us) ->
        let uu____2254 =
          let uu____2255 = FStar_Syntax_Subst.compress t1  in
          uu____2255.FStar_Syntax_Syntax.n  in
        (match uu____2254 with
         | FStar_Syntax_Syntax.Tm_fvar fv ->
             FStar_Pervasives_Native.Some (fv, us)
         | uu____2269 ->
             failwith
               "try_get_fv: Node is a Tm_uinst, but Tm_uinst is not an fvar")
    | FStar_Syntax_Syntax.Tm_ascribed (t1,uu____2278,uu____2279) ->
        try_get_fv t1
    | uu____2320 ->
        let uu____2321 =
          let uu____2323 = FStar_Syntax_Print.tag_of_term t  in
          Prims.op_Hat "try_get_fv: did not expect t to be a : " uu____2323
           in
        failwith uu____2321
  
type unfolded_memo_elt =
  (FStar_Ident.lident * FStar_Syntax_Syntax.args) Prims.list
type unfolded_memo_t = unfolded_memo_elt FStar_ST.ref
let (already_unfolded :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.args ->
      unfolded_memo_t -> FStar_TypeChecker_Env.env_t -> Prims.bool)
  =
  fun ilid  ->
    fun arrghs  ->
      fun unfolded  ->
        fun env  ->
          let uu____2363 = FStar_ST.op_Bang unfolded  in
          FStar_List.existsML
            (fun uu____2412  ->
               match uu____2412 with
               | (lid,l) ->
                   (FStar_Ident.lid_equals lid ilid) &&
                     (let args =
                        let uu____2456 =
                          FStar_List.splitAt (FStar_List.length l) arrghs  in
                        FStar_Pervasives_Native.fst uu____2456  in
                      FStar_List.fold_left2
                        (fun b  ->
                           fun a  ->
                             fun a'  ->
                               b &&
                                 (FStar_TypeChecker_Rel.teq_nosmt_force env
                                    (FStar_Pervasives_Native.fst a)
                                    (FStar_Pervasives_Native.fst a'))) true
                        args l)) uu____2363
  
let rec (ty_strictly_positive_in_type :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.term ->
      unfolded_memo_t -> FStar_TypeChecker_Env.env_t -> Prims.bool)
  =
  fun ty_lid  ->
    fun btype  ->
      fun unfolded  ->
        fun env  ->
          debug_log env
            (fun uu____2663  ->
               let uu____2664 = FStar_Syntax_Print.term_to_string btype  in
               Prims.op_Hat "Checking strict positivity in type: " uu____2664);
          (let btype1 =
             FStar_TypeChecker_Normalize.normalize
               [FStar_TypeChecker_Env.Beta;
               FStar_TypeChecker_Env.Eager_unfolding;
               FStar_TypeChecker_Env.UnfoldUntil
                 FStar_Syntax_Syntax.delta_constant;
               FStar_TypeChecker_Env.Iota;
               FStar_TypeChecker_Env.Zeta;
               FStar_TypeChecker_Env.AllowUnboundUniverses] env btype
              in
           debug_log env
             (fun uu____2671  ->
                let uu____2672 = FStar_Syntax_Print.term_to_string btype1  in
                Prims.op_Hat
                  "Checking strict positivity in type, after normalization: "
                  uu____2672);
           (let uu____2677 = ty_occurs_in ty_lid btype1  in
            Prims.op_Negation uu____2677) ||
             ((debug_log env
                 (fun uu____2687  ->
                    "ty does occur in this type, pressing ahead");
               (let uu____2689 =
                  let uu____2690 = FStar_Syntax_Subst.compress btype1  in
                  uu____2690.FStar_Syntax_Syntax.n  in
                match uu____2689 with
                | FStar_Syntax_Syntax.Tm_app (t,args) ->
                    let fv_us_opt = try_get_fv t  in
                    let uu____2727 =
                      FStar_All.pipe_right fv_us_opt FStar_Util.is_none  in
                    if uu____2727
                    then true
                    else
                      (let uu____2745 =
                         FStar_All.pipe_right fv_us_opt FStar_Util.must  in
                       match uu____2745 with
                       | (fv,us) ->
                           let uu____2767 =
                             FStar_Ident.lid_equals
                               (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                               ty_lid
                              in
                           if uu____2767
                           then
                             (debug_log env
                                (fun uu____2773  ->
                                   "Checking strict positivity in the Tm_app node where head lid is ty itself, checking that ty does not occur in the arguments");
                              FStar_List.for_all
                                (fun uu____2785  ->
                                   match uu____2785 with
                                   | (t1,uu____2794) ->
                                       let uu____2799 =
                                         ty_occurs_in ty_lid t1  in
                                       Prims.op_Negation uu____2799) args)
                           else
                             (debug_log env
                                (fun uu____2805  ->
                                   "Checking strict positivity in the Tm_app node, head lid is not ty, so checking nested positivity");
                              ty_nested_positive_in_inductive ty_lid
                                (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                                us args unfolded env))
                | FStar_Syntax_Syntax.Tm_arrow (sbs,c) ->
                    (debug_log env
                       (fun uu____2831  ->
                          "Checking strict positivity in Tm_arrow");
                     (let check_comp =
                        let c1 =
                          let uu____2838 =
                            FStar_TypeChecker_Env.unfold_effect_abbrev env c
                             in
                          FStar_All.pipe_right uu____2838
                            FStar_Syntax_Syntax.mk_Comp
                           in
                        (FStar_Syntax_Util.is_pure_or_ghost_comp c1) ||
                          (let uu____2842 =
                             FStar_TypeChecker_Env.lookup_effect_quals env
                               (FStar_Syntax_Util.comp_effect_name c1)
                              in
                           FStar_All.pipe_right uu____2842
                             (FStar_List.existsb
                                (fun q  ->
                                   q = FStar_Syntax_Syntax.TotalEffect)))
                         in
                      if Prims.op_Negation check_comp
                      then
                        (debug_log env
                           (fun uu____2854  ->
                              "Checking strict positivity , the arrow is impure, so return true");
                         true)
                      else
                        (debug_log env
                           (fun uu____2861  ->
                              "Checking struict positivity, Pure arrow, checking that ty does not occur in the binders, and that it is strictly positive in the return type");
                         (FStar_List.for_all
                            (fun uu____2873  ->
                               match uu____2873 with
                               | (b,uu____2882) ->
                                   let uu____2887 =
                                     ty_occurs_in ty_lid
                                       b.FStar_Syntax_Syntax.sort
                                      in
                                   Prims.op_Negation uu____2887) sbs)
                           &&
                           ((let uu____2893 =
                               FStar_Syntax_Subst.open_term sbs
                                 (FStar_Syntax_Util.comp_result c)
                                in
                             match uu____2893 with
                             | (uu____2899,return_type) ->
                                 let uu____2901 =
                                   FStar_TypeChecker_Env.push_binders env sbs
                                    in
                                 ty_strictly_positive_in_type ty_lid
                                   return_type unfolded uu____2901)))))
                | FStar_Syntax_Syntax.Tm_fvar uu____2902 ->
                    (debug_log env
                       (fun uu____2905  ->
                          "Checking strict positivity in an fvar, return true");
                     true)
                | FStar_Syntax_Syntax.Tm_type uu____2908 ->
                    (debug_log env
                       (fun uu____2911  ->
                          "Checking strict positivity in an Tm_type, return true");
                     true)
                | FStar_Syntax_Syntax.Tm_uinst (t,uu____2915) ->
                    (debug_log env
                       (fun uu____2922  ->
                          "Checking strict positivity in an Tm_uinst, recur on the term inside (mostly it should be the same inductive)");
                     ty_strictly_positive_in_type ty_lid t unfolded env)
                | FStar_Syntax_Syntax.Tm_refine (bv,uu____2925) ->
                    (debug_log env
                       (fun uu____2932  ->
                          "Checking strict positivity in an Tm_refine, recur in the bv sort)");
                     ty_strictly_positive_in_type ty_lid
                       bv.FStar_Syntax_Syntax.sort unfolded env)
                | FStar_Syntax_Syntax.Tm_match (uu____2934,branches) ->
                    (debug_log env
                       (fun uu____2974  ->
                          "Checking strict positivity in an Tm_match, recur in the branches)");
                     FStar_List.for_all
                       (fun uu____2995  ->
                          match uu____2995 with
                          | (p,uu____3008,t) ->
                              let bs =
                                let uu____3027 =
                                  FStar_Syntax_Syntax.pat_bvs p  in
                                FStar_List.map FStar_Syntax_Syntax.mk_binder
                                  uu____3027
                                 in
                              let uu____3036 =
                                FStar_Syntax_Subst.open_term bs t  in
                              (match uu____3036 with
                               | (bs1,t1) ->
                                   let uu____3044 =
                                     FStar_TypeChecker_Env.push_binders env
                                       bs1
                                      in
                                   ty_strictly_positive_in_type ty_lid t1
                                     unfolded uu____3044)) branches)
                | FStar_Syntax_Syntax.Tm_ascribed (t,uu____3046,uu____3047)
                    ->
                    (debug_log env
                       (fun uu____3090  ->
                          "Checking strict positivity in an Tm_ascribed, recur)");
                     ty_strictly_positive_in_type ty_lid t unfolded env)
                | uu____3092 ->
                    (debug_log env
                       (fun uu____3096  ->
                          let uu____3097 =
                            let uu____3099 =
                              FStar_Syntax_Print.tag_of_term btype1  in
                            let uu____3101 =
                              let uu____3103 =
                                FStar_Syntax_Print.term_to_string btype1  in
                              Prims.op_Hat " and term: " uu____3103  in
                            Prims.op_Hat uu____3099 uu____3101  in
                          Prims.op_Hat
                            "Checking strict positivity, unexpected tag: "
                            uu____3097);
                     false)))))

and (ty_nested_positive_in_inductive :
  FStar_Ident.lident ->
    FStar_Ident.lident ->
      FStar_Syntax_Syntax.universes ->
        FStar_Syntax_Syntax.args ->
          unfolded_memo_t -> FStar_TypeChecker_Env.env_t -> Prims.bool)
  =
  fun ty_lid  ->
    fun ilid  ->
      fun us  ->
        fun args  ->
          fun unfolded  ->
            fun env  ->
              debug_log env
                (fun uu____3118  ->
                   let uu____3119 =
                     let uu____3121 = FStar_Ident.string_of_lid ilid  in
                     let uu____3123 =
                       let uu____3125 =
                         FStar_Syntax_Print.args_to_string args  in
                       Prims.op_Hat " applied to arguments: " uu____3125  in
                     Prims.op_Hat uu____3121 uu____3123  in
                   Prims.op_Hat
                     "Checking nested positivity in the inductive "
                     uu____3119);
              (let uu____3129 =
                 FStar_TypeChecker_Env.datacons_of_typ env ilid  in
               match uu____3129 with
               | (b,idatas) ->
                   if Prims.op_Negation b
                   then
                     let uu____3148 =
                       let uu____3150 =
                         FStar_Syntax_Syntax.lid_as_fv ilid
                           FStar_Syntax_Syntax.delta_constant
                           FStar_Pervasives_Native.None
                          in
                       FStar_TypeChecker_Env.fv_has_attr env uu____3150
                         FStar_Parser_Const.assume_strictly_positive_attr_lid
                        in
                     (if uu____3148
                      then
                        (debug_log env
                           (fun uu____3156  ->
                              let uu____3157 = FStar_Ident.string_of_lid ilid
                                 in
                              FStar_Util.format1
                                "Checking nested positivity, special case decorated with `assume_strictly_positive` %s; return true"
                                uu____3157);
                         true)
                      else
                        (debug_log env
                           (fun uu____3165  ->
                              "Checking nested positivity, not an inductive, return false");
                         false))
                   else
                     (let uu____3170 =
                        already_unfolded ilid args unfolded env  in
                      if uu____3170
                      then
                        (debug_log env
                           (fun uu____3176  ->
                              "Checking nested positivity, we have already unfolded this inductive with these args");
                         true)
                      else
                        (let num_ibs =
                           let uu____3183 =
                             FStar_TypeChecker_Env.num_inductive_ty_params
                               env ilid
                              in
                           FStar_Option.get uu____3183  in
                         debug_log env
                           (fun uu____3191  ->
                              let uu____3192 =
                                let uu____3194 =
                                  FStar_Util.string_of_int num_ibs  in
                                Prims.op_Hat uu____3194
                                  ", also adding to the memo table"
                                 in
                              Prims.op_Hat
                                "Checking nested positivity, number of type parameters is "
                                uu____3192);
                         (let uu____3199 =
                            let uu____3200 = FStar_ST.op_Bang unfolded  in
                            let uu____3226 =
                              let uu____3233 =
                                let uu____3238 =
                                  let uu____3239 =
                                    FStar_List.splitAt num_ibs args  in
                                  FStar_Pervasives_Native.fst uu____3239  in
                                (ilid, uu____3238)  in
                              [uu____3233]  in
                            FStar_List.append uu____3200 uu____3226  in
                          FStar_ST.op_Colon_Equals unfolded uu____3199);
                         FStar_List.for_all
                           (fun d  ->
                              ty_nested_positive_in_dlid ty_lid d ilid us
                                args num_ibs unfolded env) idatas)))

and (ty_nested_positive_in_dlid :
  FStar_Ident.lident ->
    FStar_Ident.lident ->
      FStar_Ident.lident ->
        FStar_Syntax_Syntax.universes ->
          FStar_Syntax_Syntax.args ->
            Prims.int ->
              unfolded_memo_t -> FStar_TypeChecker_Env.env_t -> Prims.bool)
  =
  fun ty_lid  ->
    fun dlid  ->
      fun ilid  ->
        fun us  ->
          fun args  ->
            fun num_ibs  ->
              fun unfolded  ->
                fun env  ->
                  debug_log env
                    (fun uu____3338  ->
                       let uu____3339 =
                         let uu____3341 = FStar_Ident.string_of_lid dlid  in
                         let uu____3343 =
                           let uu____3345 = FStar_Ident.string_of_lid ilid
                              in
                           Prims.op_Hat " of the inductive " uu____3345  in
                         Prims.op_Hat uu____3341 uu____3343  in
                       Prims.op_Hat
                         "Checking nested positivity in data constructor "
                         uu____3339);
                  (let uu____3349 =
                     FStar_TypeChecker_Env.lookup_datacon env dlid  in
                   match uu____3349 with
                   | (univ_unif_vars,dt) ->
                       (FStar_List.iter2
                          (fun u'  ->
                             fun u  ->
                               match u' with
                               | FStar_Syntax_Syntax.U_unif u'' ->
                                   FStar_Syntax_Unionfind.univ_change u'' u
                               | uu____3372 ->
                                   failwith
                                     "Impossible! Expected universe unification variables")
                          univ_unif_vars us;
                        (let dt1 =
                           FStar_TypeChecker_Normalize.normalize
                             [FStar_TypeChecker_Env.Beta;
                             FStar_TypeChecker_Env.Eager_unfolding;
                             FStar_TypeChecker_Env.UnfoldUntil
                               FStar_Syntax_Syntax.delta_constant;
                             FStar_TypeChecker_Env.Iota;
                             FStar_TypeChecker_Env.Zeta;
                             FStar_TypeChecker_Env.AllowUnboundUniverses] env
                             dt
                            in
                         debug_log env
                           (fun uu____3378  ->
                              let uu____3379 =
                                FStar_Syntax_Print.term_to_string dt1  in
                              Prims.op_Hat
                                "Checking nested positivity in the data constructor type: "
                                uu____3379);
                         (let uu____3382 =
                            let uu____3383 = FStar_Syntax_Subst.compress dt1
                               in
                            uu____3383.FStar_Syntax_Syntax.n  in
                          match uu____3382 with
                          | FStar_Syntax_Syntax.Tm_arrow (dbs,c) ->
                              (debug_log env
                                 (fun uu____3411  ->
                                    "Checked nested positivity in Tm_arrow data constructor type");
                               (let uu____3413 =
                                  FStar_List.splitAt num_ibs dbs  in
                                match uu____3413 with
                                | (ibs,dbs1) ->
                                    let ibs1 =
                                      FStar_Syntax_Subst.open_binders ibs  in
                                    let dbs2 =
                                      let uu____3477 =
                                        FStar_Syntax_Subst.opening_of_binders
                                          ibs1
                                         in
                                      FStar_Syntax_Subst.subst_binders
                                        uu____3477 dbs1
                                       in
                                    let c1 =
                                      let uu____3481 =
                                        FStar_Syntax_Subst.opening_of_binders
                                          ibs1
                                         in
                                      FStar_Syntax_Subst.subst_comp
                                        uu____3481 c
                                       in
                                    let uu____3484 =
                                      FStar_List.splitAt num_ibs args  in
                                    (match uu____3484 with
                                     | (args1,uu____3519) ->
                                         let subst =
                                           FStar_List.fold_left2
                                             (fun subst  ->
                                                fun ib  ->
                                                  fun arg  ->
                                                    FStar_List.append subst
                                                      [FStar_Syntax_Syntax.NT
                                                         ((FStar_Pervasives_Native.fst
                                                             ib),
                                                           (FStar_Pervasives_Native.fst
                                                              arg))]) [] ibs1
                                             args1
                                            in
                                         let dbs3 =
                                           FStar_Syntax_Subst.subst_binders
                                             subst dbs2
                                            in
                                         let c2 =
                                           let uu____3611 =
                                             FStar_Syntax_Subst.shift_subst
                                               (FStar_List.length dbs3) subst
                                              in
                                           FStar_Syntax_Subst.subst_comp
                                             uu____3611 c1
                                            in
                                         (debug_log env
                                            (fun uu____3623  ->
                                               let uu____3624 =
                                                 let uu____3626 =
                                                   FStar_Syntax_Print.binders_to_string
                                                     "; " dbs3
                                                    in
                                                 let uu____3629 =
                                                   let uu____3631 =
                                                     FStar_Syntax_Print.comp_to_string
                                                       c2
                                                      in
                                                   Prims.op_Hat ", and c: "
                                                     uu____3631
                                                    in
                                                 Prims.op_Hat uu____3626
                                                   uu____3629
                                                  in
                                               Prims.op_Hat
                                                 "Checking nested positivity in the unfolded data constructor binders as: "
                                                 uu____3624);
                                          ty_nested_positive_in_type ty_lid
                                            (FStar_Syntax_Syntax.Tm_arrow
                                               (dbs3, c2)) ilid num_ibs
                                            unfolded env))))
                          | uu____3645 ->
                              (debug_log env
                                 (fun uu____3648  ->
                                    "Checking nested positivity in the data constructor type that is not an arrow");
                               (let uu____3650 =
                                  let uu____3651 =
                                    FStar_Syntax_Subst.compress dt1  in
                                  uu____3651.FStar_Syntax_Syntax.n  in
                                ty_nested_positive_in_type ty_lid uu____3650
                                  ilid num_ibs unfolded env))))))

and (ty_nested_positive_in_type :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.term' ->
      FStar_Ident.lident ->
        Prims.int ->
          unfolded_memo_t -> FStar_TypeChecker_Env.env_t -> Prims.bool)
  =
  fun ty_lid  ->
    fun t  ->
      fun ilid  ->
        fun num_ibs  ->
          fun unfolded  ->
            fun env  ->
              match t with
              | FStar_Syntax_Syntax.Tm_app (t1,args) ->
                  (debug_log env
                     (fun uu____3690  ->
                        "Checking nested positivity in an Tm_app node, which is expected to be the ilid itself");
                   (let uu____3692 =
                      let uu____3697 = try_get_fv t1  in
                      FStar_All.pipe_right uu____3697 FStar_Util.must  in
                    match uu____3692 with
                    | (fv,uu____3720) ->
                        let uu____3721 =
                          FStar_Ident.lid_equals
                            (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                            ilid
                           in
                        if uu____3721
                        then true
                        else
                          failwith "Impossible, expected the type to be ilid"))
              | FStar_Syntax_Syntax.Tm_arrow (sbs,c) ->
                  (debug_log env
                     (fun uu____3755  ->
                        let uu____3756 =
                          FStar_Syntax_Print.binders_to_string "; " sbs  in
                        Prims.op_Hat
                          "Checking nested positivity in an Tm_arrow node, with binders as: "
                          uu____3756);
                   (let sbs1 = FStar_Syntax_Subst.open_binders sbs  in
                    let uu____3761 =
                      FStar_List.fold_left
                        (fun uu____3782  ->
                           fun b  ->
                             match uu____3782 with
                             | (r,env1) ->
                                 if Prims.op_Negation r
                                 then (r, env1)
                                 else
                                   (let uu____3813 =
                                      ty_strictly_positive_in_type ty_lid
                                        (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort
                                        unfolded env1
                                       in
                                    let uu____3817 =
                                      FStar_TypeChecker_Env.push_binders env1
                                        [b]
                                       in
                                    (uu____3813, uu____3817))) (true, env)
                        sbs1
                       in
                    match uu____3761 with | (b,uu____3835) -> b))
              | uu____3838 ->
                  failwith "Nested positive check, unhandled case"

let (ty_positive_in_datacon :
  FStar_Ident.lident ->
    FStar_Ident.lident ->
      FStar_Syntax_Syntax.binders ->
        FStar_Syntax_Syntax.universes ->
          unfolded_memo_t -> FStar_TypeChecker_Env.env -> Prims.bool)
  =
  fun ty_lid  ->
    fun dlid  ->
      fun ty_bs  ->
        fun us  ->
          fun unfolded  ->
            fun env  ->
              let uu____3874 = FStar_TypeChecker_Env.lookup_datacon env dlid
                 in
              match uu____3874 with
              | (univ_unif_vars,dt) ->
                  (FStar_List.iter2
                     (fun u'  ->
                        fun u  ->
                          match u' with
                          | FStar_Syntax_Syntax.U_unif u'' ->
                              FStar_Syntax_Unionfind.univ_change u'' u
                          | uu____3897 ->
                              failwith
                                "Impossible! Expected universe unification variables")
                     univ_unif_vars us;
                   debug_log env
                     (fun uu____3902  ->
                        let uu____3903 = FStar_Syntax_Print.term_to_string dt
                           in
                        Prims.op_Hat "Checking data constructor type: "
                          uu____3903);
                   (let uu____3906 =
                      let uu____3907 = FStar_Syntax_Subst.compress dt  in
                      uu____3907.FStar_Syntax_Syntax.n  in
                    match uu____3906 with
                    | FStar_Syntax_Syntax.Tm_fvar uu____3911 ->
                        (debug_log env
                           (fun uu____3914  ->
                              "Data constructor type is simply an fvar, returning true");
                         true)
                    | FStar_Syntax_Syntax.Tm_arrow (dbs,uu____3918) ->
                        let dbs1 =
                          let uu____3948 =
                            FStar_List.splitAt (FStar_List.length ty_bs) dbs
                             in
                          FStar_Pervasives_Native.snd uu____3948  in
                        let dbs2 =
                          let uu____3998 =
                            FStar_Syntax_Subst.opening_of_binders ty_bs  in
                          FStar_Syntax_Subst.subst_binders uu____3998 dbs1
                           in
                        let dbs3 = FStar_Syntax_Subst.open_binders dbs2  in
                        (debug_log env
                           (fun uu____4005  ->
                              let uu____4006 =
                                let uu____4008 =
                                  FStar_Util.string_of_int
                                    (FStar_List.length dbs3)
                                   in
                                Prims.op_Hat uu____4008 " binders"  in
                              Prims.op_Hat
                                "Data constructor type is an arrow type, so checking strict positivity in "
                                uu____4006);
                         (let uu____4018 =
                            FStar_List.fold_left
                              (fun uu____4039  ->
                                 fun b  ->
                                   match uu____4039 with
                                   | (r,env1) ->
                                       if Prims.op_Negation r
                                       then (r, env1)
                                       else
                                         (let uu____4070 =
                                            ty_strictly_positive_in_type
                                              ty_lid
                                              (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort
                                              unfolded env1
                                             in
                                          let uu____4074 =
                                            FStar_TypeChecker_Env.push_binders
                                              env1 [b]
                                             in
                                          (uu____4070, uu____4074)))
                              (true, env) dbs3
                             in
                          match uu____4018 with | (b,uu____4092) -> b))
                    | FStar_Syntax_Syntax.Tm_app (uu____4095,uu____4096) ->
                        (debug_log env
                           (fun uu____4123  ->
                              "Data constructor type is a Tm_app, so returning true");
                         true)
                    | FStar_Syntax_Syntax.Tm_uinst (t,univs) ->
                        (debug_log env
                           (fun uu____4134  ->
                              "Data constructor type is a Tm_uinst, so recursing in the base type");
                         ty_strictly_positive_in_type ty_lid t unfolded env)
                    | uu____4136 ->
                        failwith
                          "Unexpected data constructor type when checking positivity"))
  
let (check_positivity :
  FStar_Syntax_Syntax.sigelt -> FStar_TypeChecker_Env.env -> Prims.bool) =
  fun ty  ->
    fun env  ->
      let unfolded_inductives = FStar_Util.mk_ref []  in
      let uu____4159 =
        match ty.FStar_Syntax_Syntax.sigel with
        | FStar_Syntax_Syntax.Sig_inductive_typ
            (lid,us,bs,uu____4175,uu____4176,uu____4177) -> (lid, us, bs)
        | uu____4186 -> failwith "Impossible!"  in
      match uu____4159 with
      | (ty_lid,ty_us,ty_bs) ->
          let uu____4198 = FStar_Syntax_Subst.univ_var_opening ty_us  in
          (match uu____4198 with
           | (ty_usubst,ty_us1) ->
               let env1 = FStar_TypeChecker_Env.push_univ_vars env ty_us1  in
               let env2 = FStar_TypeChecker_Env.push_binders env1 ty_bs  in
               let ty_bs1 = FStar_Syntax_Subst.subst_binders ty_usubst ty_bs
                  in
               let ty_bs2 = FStar_Syntax_Subst.open_binders ty_bs1  in
               let uu____4222 =
                 let uu____4225 =
                   FStar_TypeChecker_Env.datacons_of_typ env2 ty_lid  in
                 FStar_Pervasives_Native.snd uu____4225  in
               FStar_List.for_all
                 (fun d  ->
                    let uu____4239 =
                      FStar_List.map (fun s  -> FStar_Syntax_Syntax.U_name s)
                        ty_us1
                       in
                    ty_positive_in_datacon ty_lid d ty_bs2 uu____4239
                      unfolded_inductives env2) uu____4222)
  
let (check_exn_positivity :
  FStar_Ident.lid -> FStar_TypeChecker_Env.env -> Prims.bool) =
  fun data_ctor_lid  ->
    fun env  ->
      let unfolded_inductives = FStar_Util.mk_ref []  in
      ty_positive_in_datacon FStar_Parser_Const.exn_lid data_ctor_lid [] []
        unfolded_inductives env
  
let (datacon_typ : FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.term) =
  fun data  ->
    match data.FStar_Syntax_Syntax.sigel with
    | FStar_Syntax_Syntax.Sig_datacon
        (uu____4274,uu____4275,t,uu____4277,uu____4278,uu____4279) -> t
    | uu____4286 -> failwith "Impossible!"
  
let (haseq_suffix : Prims.string) = "__uu___haseq" 
let (is_haseq_lid : FStar_Ident.lid -> Prims.bool) =
  fun lid  ->
    let str = FStar_Ident.string_of_lid lid  in
    let len = FStar_String.length str  in
    let haseq_suffix_len = FStar_String.length haseq_suffix  in
    (len > haseq_suffix_len) &&
      (let uu____4303 =
         let uu____4305 =
           FStar_String.substring str (len - haseq_suffix_len)
             haseq_suffix_len
            in
         FStar_String.compare uu____4305 haseq_suffix  in
       uu____4303 = Prims.int_zero)
  
let (get_haseq_axiom_lid : FStar_Ident.lid -> FStar_Ident.lid) =
  fun lid  ->
    let uu____4315 =
      let uu____4316 = FStar_Ident.ns_of_lid lid  in
      let uu____4319 =
        let uu____4322 =
          let uu____4323 =
            let uu____4325 =
              let uu____4327 = FStar_Ident.ident_of_lid lid  in
              FStar_Ident.text_of_id uu____4327  in
            Prims.op_Hat uu____4325 haseq_suffix  in
          FStar_Ident.id_of_text uu____4323  in
        [uu____4322]  in
      FStar_List.append uu____4316 uu____4319  in
    FStar_Ident.lid_of_ids uu____4315
  
let (get_optimized_haseq_axiom :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.sigelt ->
      FStar_Syntax_Syntax.subst_elt Prims.list ->
        FStar_Syntax_Syntax.univ_names ->
          (FStar_Ident.lident * FStar_Syntax_Syntax.term *
            FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.binders *
            FStar_Syntax_Syntax.term))
  =
  fun en  ->
    fun ty  ->
      fun usubst  ->
        fun us  ->
          let uu____4373 =
            match ty.FStar_Syntax_Syntax.sigel with
            | FStar_Syntax_Syntax.Sig_inductive_typ
                (lid,uu____4387,bs,t,uu____4390,uu____4391) -> (lid, bs, t)
            | uu____4400 -> failwith "Impossible!"  in
          match uu____4373 with
          | (lid,bs,t) ->
              let bs1 = FStar_Syntax_Subst.subst_binders usubst bs  in
              let t1 =
                let uu____4423 =
                  FStar_Syntax_Subst.shift_subst (FStar_List.length bs1)
                    usubst
                   in
                FStar_Syntax_Subst.subst uu____4423 t  in
              let uu____4432 = FStar_Syntax_Subst.open_term bs1 t1  in
              (match uu____4432 with
               | (bs2,t2) ->
                   let ibs =
                     let uu____4450 =
                       let uu____4451 = FStar_Syntax_Subst.compress t2  in
                       uu____4451.FStar_Syntax_Syntax.n  in
                     match uu____4450 with
                     | FStar_Syntax_Syntax.Tm_arrow (ibs,uu____4455) -> ibs
                     | uu____4476 -> []  in
                   let ibs1 = FStar_Syntax_Subst.open_binders ibs  in
                   let ind =
                     let uu____4485 =
                       FStar_Syntax_Syntax.fvar lid
                         FStar_Syntax_Syntax.delta_constant
                         FStar_Pervasives_Native.None
                        in
                     let uu____4486 =
                       FStar_List.map
                         (fun u  -> FStar_Syntax_Syntax.U_name u) us
                        in
                     FStar_Syntax_Syntax.mk_Tm_uinst uu____4485 uu____4486
                      in
                   let ind1 =
                     let uu____4492 =
                       let uu____4497 =
                         FStar_List.map
                           (fun uu____4514  ->
                              match uu____4514 with
                              | (bv,aq) ->
                                  let uu____4533 =
                                    FStar_Syntax_Syntax.bv_to_name bv  in
                                  (uu____4533, aq)) bs2
                          in
                       FStar_Syntax_Syntax.mk_Tm_app ind uu____4497  in
                     uu____4492 FStar_Pervasives_Native.None
                       FStar_Range.dummyRange
                      in
                   let ind2 =
                     let uu____4539 =
                       let uu____4544 =
                         FStar_List.map
                           (fun uu____4561  ->
                              match uu____4561 with
                              | (bv,aq) ->
                                  let uu____4580 =
                                    FStar_Syntax_Syntax.bv_to_name bv  in
                                  (uu____4580, aq)) ibs1
                          in
                       FStar_Syntax_Syntax.mk_Tm_app ind1 uu____4544  in
                     uu____4539 FStar_Pervasives_Native.None
                       FStar_Range.dummyRange
                      in
                   let haseq_ind =
                     let uu____4586 =
                       let uu____4591 =
                         let uu____4592 = FStar_Syntax_Syntax.as_arg ind2  in
                         [uu____4592]  in
                       FStar_Syntax_Syntax.mk_Tm_app
                         FStar_Syntax_Util.t_haseq uu____4591
                        in
                     uu____4586 FStar_Pervasives_Native.None
                       FStar_Range.dummyRange
                      in
                   let bs' =
                     FStar_List.filter
                       (fun b  ->
                          let uu____4641 =
                            let uu____4642 = FStar_Syntax_Util.type_u ()  in
                            FStar_Pervasives_Native.fst uu____4642  in
                          FStar_TypeChecker_Rel.subtype_nosmt_force en
                            (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort
                            uu____4641) bs2
                      in
                   let haseq_bs =
                     FStar_List.fold_left
                       (fun t3  ->
                          fun b  ->
                            let uu____4655 =
                              let uu____4658 =
                                let uu____4663 =
                                  let uu____4664 =
                                    let uu____4673 =
                                      FStar_Syntax_Syntax.bv_to_name
                                        (FStar_Pervasives_Native.fst b)
                                       in
                                    FStar_Syntax_Syntax.as_arg uu____4673  in
                                  [uu____4664]  in
                                FStar_Syntax_Syntax.mk_Tm_app
                                  FStar_Syntax_Util.t_haseq uu____4663
                                 in
                              uu____4658 FStar_Pervasives_Native.None
                                FStar_Range.dummyRange
                               in
                            FStar_Syntax_Util.mk_conj t3 uu____4655)
                       FStar_Syntax_Util.t_true bs'
                      in
                   let fml = FStar_Syntax_Util.mk_imp haseq_bs haseq_ind  in
                   let fml1 =
                     let uu___676_4696 = fml  in
                     let uu____4697 =
                       let uu____4698 =
                         let uu____4705 =
                           let uu____4706 =
                             let uu____4727 =
                               FStar_Syntax_Syntax.binders_to_names ibs1  in
                             let uu____4732 =
                               let uu____4745 =
                                 let uu____4756 =
                                   FStar_Syntax_Syntax.as_arg haseq_ind  in
                                 [uu____4756]  in
                               [uu____4745]  in
                             (uu____4727, uu____4732)  in
                           FStar_Syntax_Syntax.Meta_pattern uu____4706  in
                         (fml, uu____4705)  in
                       FStar_Syntax_Syntax.Tm_meta uu____4698  in
                     {
                       FStar_Syntax_Syntax.n = uu____4697;
                       FStar_Syntax_Syntax.pos =
                         (uu___676_4696.FStar_Syntax_Syntax.pos);
                       FStar_Syntax_Syntax.vars =
                         (uu___676_4696.FStar_Syntax_Syntax.vars)
                     }  in
                   let fml2 =
                     FStar_List.fold_right
                       (fun b  ->
                          fun t3  ->
                            let uu____4825 =
                              let uu____4830 =
                                let uu____4831 =
                                  let uu____4840 =
                                    let uu____4841 =
                                      FStar_Syntax_Subst.close [b] t3  in
                                    FStar_Syntax_Util.abs
                                      [((FStar_Pervasives_Native.fst b),
                                         FStar_Pervasives_Native.None)]
                                      uu____4841 FStar_Pervasives_Native.None
                                     in
                                  FStar_Syntax_Syntax.as_arg uu____4840  in
                                [uu____4831]  in
                              FStar_Syntax_Syntax.mk_Tm_app
                                FStar_Syntax_Util.tforall uu____4830
                               in
                            uu____4825 FStar_Pervasives_Native.None
                              FStar_Range.dummyRange) ibs1 fml1
                      in
                   let fml3 =
                     FStar_List.fold_right
                       (fun b  ->
                          fun t3  ->
                            let uu____4894 =
                              let uu____4899 =
                                let uu____4900 =
                                  let uu____4909 =
                                    let uu____4910 =
                                      FStar_Syntax_Subst.close [b] t3  in
                                    FStar_Syntax_Util.abs
                                      [((FStar_Pervasives_Native.fst b),
                                         FStar_Pervasives_Native.None)]
                                      uu____4910 FStar_Pervasives_Native.None
                                     in
                                  FStar_Syntax_Syntax.as_arg uu____4909  in
                                [uu____4900]  in
                              FStar_Syntax_Syntax.mk_Tm_app
                                FStar_Syntax_Util.tforall uu____4899
                               in
                            uu____4894 FStar_Pervasives_Native.None
                              FStar_Range.dummyRange) bs2 fml2
                      in
                   let axiom_lid = get_haseq_axiom_lid lid  in
                   (axiom_lid, fml3, bs2, ibs1, haseq_bs))
  
let (optimized_haseq_soundness_for_data :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.sigelt ->
      FStar_Syntax_Syntax.subst_elt Prims.list ->
        FStar_Syntax_Syntax.binders -> FStar_Syntax_Syntax.term)
  =
  fun ty_lid  ->
    fun data  ->
      fun usubst  ->
        fun bs  ->
          let dt = datacon_typ data  in
          let dt1 = FStar_Syntax_Subst.subst usubst dt  in
          let uu____4985 =
            let uu____4986 = FStar_Syntax_Subst.compress dt1  in
            uu____4986.FStar_Syntax_Syntax.n  in
          match uu____4985 with
          | FStar_Syntax_Syntax.Tm_arrow (dbs,uu____4990) ->
              let dbs1 =
                let uu____5020 =
                  FStar_List.splitAt (FStar_List.length bs) dbs  in
                FStar_Pervasives_Native.snd uu____5020  in
              let dbs2 =
                let uu____5070 = FStar_Syntax_Subst.opening_of_binders bs  in
                FStar_Syntax_Subst.subst_binders uu____5070 dbs1  in
              let dbs3 = FStar_Syntax_Subst.open_binders dbs2  in
              let cond =
                FStar_List.fold_left
                  (fun t  ->
                     fun b  ->
                       let haseq_b =
                         let uu____5085 =
                           let uu____5090 =
                             let uu____5091 =
                               FStar_Syntax_Syntax.as_arg
                                 (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort
                                in
                             [uu____5091]  in
                           FStar_Syntax_Syntax.mk_Tm_app
                             FStar_Syntax_Util.t_haseq uu____5090
                            in
                         uu____5085 FStar_Pervasives_Native.None
                           FStar_Range.dummyRange
                          in
                       let sort_range =
                         ((FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort).FStar_Syntax_Syntax.pos
                          in
                       let haseq_b1 =
                         let uu____5122 =
                           let uu____5124 = FStar_Ident.string_of_lid ty_lid
                              in
                           FStar_Util.format1
                             "Failed to prove that the type '%s' supports decidable equality because of this argument; add either the 'noeq' or 'unopteq' qualifier"
                             uu____5124
                            in
                         FStar_TypeChecker_Util.label uu____5122 sort_range
                           haseq_b
                          in
                       FStar_Syntax_Util.mk_conj t haseq_b1)
                  FStar_Syntax_Util.t_true dbs3
                 in
              FStar_List.fold_right
                (fun b  ->
                   fun t  ->
                     let uu____5132 =
                       let uu____5137 =
                         let uu____5138 =
                           let uu____5147 =
                             let uu____5148 = FStar_Syntax_Subst.close [b] t
                                in
                             FStar_Syntax_Util.abs
                               [((FStar_Pervasives_Native.fst b),
                                  FStar_Pervasives_Native.None)] uu____5148
                               FStar_Pervasives_Native.None
                              in
                           FStar_Syntax_Syntax.as_arg uu____5147  in
                         [uu____5138]  in
                       FStar_Syntax_Syntax.mk_Tm_app
                         FStar_Syntax_Util.tforall uu____5137
                        in
                     uu____5132 FStar_Pervasives_Native.None
                       FStar_Range.dummyRange) dbs3 cond
          | uu____5195 -> FStar_Syntax_Util.t_true
  
let (optimized_haseq_ty :
  FStar_Syntax_Syntax.sigelts ->
    FStar_Syntax_Syntax.subst_elt Prims.list ->
      FStar_Syntax_Syntax.univ_name Prims.list ->
        ((FStar_Ident.lident * FStar_Syntax_Syntax.term) Prims.list *
          FStar_TypeChecker_Env.env * FStar_Syntax_Syntax.term'
          FStar_Syntax_Syntax.syntax * FStar_Syntax_Syntax.term'
          FStar_Syntax_Syntax.syntax) ->
          FStar_Syntax_Syntax.sigelt ->
            ((FStar_Ident.lident * FStar_Syntax_Syntax.term) Prims.list *
              FStar_TypeChecker_Env.env * FStar_Syntax_Syntax.term'
              FStar_Syntax_Syntax.syntax * FStar_Syntax_Syntax.term'
              FStar_Syntax_Syntax.syntax))
  =
  fun all_datas_in_the_bundle  ->
    fun usubst  ->
      fun us  ->
        fun acc  ->
          fun ty  ->
            let lid =
              match ty.FStar_Syntax_Syntax.sigel with
              | FStar_Syntax_Syntax.Sig_inductive_typ
                  (lid,uu____5286,uu____5287,uu____5288,uu____5289,uu____5290)
                  -> lid
              | uu____5299 -> failwith "Impossible!"  in
            let uu____5301 = acc  in
            match uu____5301 with
            | (uu____5338,en,uu____5340,uu____5341) ->
                let uu____5362 = get_optimized_haseq_axiom en ty usubst us
                   in
                (match uu____5362 with
                 | (axiom_lid,fml,bs,ibs,haseq_bs) ->
                     let guard = FStar_Syntax_Util.mk_conj haseq_bs fml  in
                     let uu____5399 = acc  in
                     (match uu____5399 with
                      | (l_axioms,env,guard',cond') ->
                          let env1 =
                            FStar_TypeChecker_Env.push_binders env bs  in
                          let env2 =
                            FStar_TypeChecker_Env.push_binders env1 ibs  in
                          let t_datas =
                            FStar_List.filter
                              (fun s  ->
                                 match s.FStar_Syntax_Syntax.sigel with
                                 | FStar_Syntax_Syntax.Sig_datacon
                                     (uu____5474,uu____5475,uu____5476,t_lid,uu____5478,uu____5479)
                                     -> t_lid = lid
                                 | uu____5486 -> failwith "Impossible")
                              all_datas_in_the_bundle
                             in
                          let cond =
                            FStar_List.fold_left
                              (fun acc1  ->
                                 fun d  ->
                                   let uu____5501 =
                                     optimized_haseq_soundness_for_data lid d
                                       usubst bs
                                      in
                                   FStar_Syntax_Util.mk_conj acc1 uu____5501)
                              FStar_Syntax_Util.t_true t_datas
                             in
                          let uu____5504 =
                            FStar_Syntax_Util.mk_conj guard' guard  in
                          let uu____5507 =
                            FStar_Syntax_Util.mk_conj cond' cond  in
                          ((FStar_List.append l_axioms [(axiom_lid, fml)]),
                            env2, uu____5504, uu____5507)))
  
let (optimized_haseq_scheme :
  FStar_Syntax_Syntax.sigelt ->
    FStar_Syntax_Syntax.sigelt Prims.list ->
      FStar_Syntax_Syntax.sigelt Prims.list ->
        FStar_TypeChecker_Env.env_t -> FStar_Syntax_Syntax.sigelt Prims.list)
  =
  fun sig_bndle  ->
    fun tcs  ->
      fun datas  ->
        fun env0  ->
          let uu____5565 =
            let ty = FStar_List.hd tcs  in
            match ty.FStar_Syntax_Syntax.sigel with
            | FStar_Syntax_Syntax.Sig_inductive_typ
                (uu____5575,us,uu____5577,t,uu____5579,uu____5580) -> 
                (us, t)
            | uu____5589 -> failwith "Impossible!"  in
          match uu____5565 with
          | (us,t) ->
              let uu____5599 = FStar_Syntax_Subst.univ_var_opening us  in
              (match uu____5599 with
               | (usubst,us1) ->
                   let env = FStar_TypeChecker_Env.push_sigelt env0 sig_bndle
                      in
                   ((env.FStar_TypeChecker_Env.solver).FStar_TypeChecker_Env.push
                      "haseq";
                    (env.FStar_TypeChecker_Env.solver).FStar_TypeChecker_Env.encode_sig
                      env sig_bndle;
                    (let env1 = FStar_TypeChecker_Env.push_univ_vars env us1
                        in
                     let uu____5625 =
                       FStar_List.fold_left
                         (optimized_haseq_ty datas usubst us1)
                         ([], env1, FStar_Syntax_Util.t_true,
                           FStar_Syntax_Util.t_true) tcs
                        in
                     match uu____5625 with
                     | (axioms,env2,guard,cond) ->
                         let phi =
                           let uu____5703 = FStar_Syntax_Util.arrow_formals t
                              in
                           match uu____5703 with
                           | (uu____5710,t1) ->
                               let uu____5716 =
                                 FStar_Syntax_Util.is_eqtype_no_unrefine t1
                                  in
                               if uu____5716
                               then cond
                               else FStar_Syntax_Util.mk_imp guard cond
                            in
                         let uu____5721 =
                           FStar_TypeChecker_TcTerm.tc_trivial_guard env2 phi
                            in
                         (match uu____5721 with
                          | (phi1,uu____5729) ->
                              ((let uu____5731 =
                                  FStar_TypeChecker_Env.should_verify env2
                                   in
                                if uu____5731
                                then
                                  let uu____5734 =
                                    FStar_TypeChecker_Env.guard_of_guard_formula
                                      (FStar_TypeChecker_Common.NonTrivial
                                         phi1)
                                     in
                                  FStar_TypeChecker_Rel.force_trivial_guard
                                    env2 uu____5734
                                else ());
                               (let ses =
                                  FStar_List.fold_left
                                    (fun l  ->
                                       fun uu____5752  ->
                                         match uu____5752 with
                                         | (lid,fml) ->
                                             let fml1 =
                                               FStar_Syntax_Subst.close_univ_vars
                                                 us1 fml
                                                in
                                             FStar_List.append l
                                               [{
                                                  FStar_Syntax_Syntax.sigel =
                                                    (FStar_Syntax_Syntax.Sig_assume
                                                       (lid, us1, fml1));
                                                  FStar_Syntax_Syntax.sigrng
                                                    = FStar_Range.dummyRange;
                                                  FStar_Syntax_Syntax.sigquals
                                                    = [];
                                                  FStar_Syntax_Syntax.sigmeta
                                                    =
                                                    FStar_Syntax_Syntax.default_sigmeta;
                                                  FStar_Syntax_Syntax.sigattrs
                                                    = [];
                                                  FStar_Syntax_Syntax.sigopts
                                                    =
                                                    FStar_Pervasives_Native.None
                                                }]) [] axioms
                                   in
                                (env2.FStar_TypeChecker_Env.solver).FStar_TypeChecker_Env.pop
                                  "haseq";
                                ses))))))
  
let (unoptimized_haseq_data :
  FStar_Syntax_Syntax.subst_elt Prims.list ->
    FStar_Syntax_Syntax.binders ->
      FStar_Syntax_Syntax.term ->
        FStar_Ident.lident Prims.list ->
          FStar_Syntax_Syntax.term ->
            FStar_Syntax_Syntax.sigelt ->
              FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun usubst  ->
    fun bs  ->
      fun haseq_ind  ->
        fun mutuals  ->
          fun acc  ->
            fun data  ->
              let rec is_mutual t =
                let uu____5824 =
                  let uu____5825 = FStar_Syntax_Subst.compress t  in
                  uu____5825.FStar_Syntax_Syntax.n  in
                match uu____5824 with
                | FStar_Syntax_Syntax.Tm_fvar fv ->
                    FStar_List.existsb
                      (fun lid  ->
                         FStar_Ident.lid_equals lid
                           (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v)
                      mutuals
                | FStar_Syntax_Syntax.Tm_uinst (t',uu____5833) ->
                    is_mutual t'
                | FStar_Syntax_Syntax.Tm_refine (bv,t') ->
                    is_mutual bv.FStar_Syntax_Syntax.sort
                | FStar_Syntax_Syntax.Tm_app (t',args) ->
                    let uu____5870 = is_mutual t'  in
                    if uu____5870
                    then true
                    else
                      (let uu____5877 =
                         FStar_List.map FStar_Pervasives_Native.fst args  in
                       exists_mutual uu____5877)
                | FStar_Syntax_Syntax.Tm_meta (t',uu____5897) -> is_mutual t'
                | uu____5902 -> false
              
              and exists_mutual uu___1_5904 =
                match uu___1_5904 with
                | [] -> false
                | hd::tl -> (is_mutual hd) || (exists_mutual tl)
               in
              let dt = datacon_typ data  in
              let dt1 = FStar_Syntax_Subst.subst usubst dt  in
              let uu____5925 =
                let uu____5926 = FStar_Syntax_Subst.compress dt1  in
                uu____5926.FStar_Syntax_Syntax.n  in
              match uu____5925 with
              | FStar_Syntax_Syntax.Tm_arrow (dbs,uu____5932) ->
                  let dbs1 =
                    let uu____5962 =
                      FStar_List.splitAt (FStar_List.length bs) dbs  in
                    FStar_Pervasives_Native.snd uu____5962  in
                  let dbs2 =
                    let uu____6012 = FStar_Syntax_Subst.opening_of_binders bs
                       in
                    FStar_Syntax_Subst.subst_binders uu____6012 dbs1  in
                  let dbs3 = FStar_Syntax_Subst.open_binders dbs2  in
                  let cond =
                    FStar_List.fold_left
                      (fun t  ->
                         fun b  ->
                           let sort =
                             (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort
                              in
                           let haseq_sort =
                             let uu____6032 =
                               let uu____6037 =
                                 let uu____6038 =
                                   FStar_Syntax_Syntax.as_arg
                                     (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort
                                    in
                                 [uu____6038]  in
                               FStar_Syntax_Syntax.mk_Tm_app
                                 FStar_Syntax_Util.t_haseq uu____6037
                                in
                             uu____6032 FStar_Pervasives_Native.None
                               FStar_Range.dummyRange
                              in
                           let haseq_sort1 =
                             let uu____6068 = is_mutual sort  in
                             if uu____6068
                             then
                               FStar_Syntax_Util.mk_imp haseq_ind haseq_sort
                             else haseq_sort  in
                           FStar_Syntax_Util.mk_conj t haseq_sort1)
                      FStar_Syntax_Util.t_true dbs3
                     in
                  let cond1 =
                    FStar_List.fold_right
                      (fun b  ->
                         fun t  ->
                           let uu____6081 =
                             let uu____6086 =
                               let uu____6087 =
                                 let uu____6096 =
                                   let uu____6097 =
                                     FStar_Syntax_Subst.close [b] t  in
                                   FStar_Syntax_Util.abs
                                     [((FStar_Pervasives_Native.fst b),
                                        FStar_Pervasives_Native.None)]
                                     uu____6097 FStar_Pervasives_Native.None
                                    in
                                 FStar_Syntax_Syntax.as_arg uu____6096  in
                               [uu____6087]  in
                             FStar_Syntax_Syntax.mk_Tm_app
                               FStar_Syntax_Util.tforall uu____6086
                              in
                           uu____6081 FStar_Pervasives_Native.None
                             FStar_Range.dummyRange) dbs3 cond
                     in
                  FStar_Syntax_Util.mk_conj acc cond1
              | uu____6144 -> acc
  
let (unoptimized_haseq_ty :
  FStar_Syntax_Syntax.sigelt Prims.list ->
    FStar_Ident.lident Prims.list ->
      FStar_Syntax_Syntax.subst_elt Prims.list ->
        FStar_Syntax_Syntax.univ_name Prims.list ->
          FStar_Syntax_Syntax.term ->
            FStar_Syntax_Syntax.sigelt ->
              FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun all_datas_in_the_bundle  ->
    fun mutuals  ->
      fun usubst  ->
        fun us  ->
          fun acc  ->
            fun ty  ->
              let uu____6194 =
                match ty.FStar_Syntax_Syntax.sigel with
                | FStar_Syntax_Syntax.Sig_inductive_typ
                    (lid,uu____6216,bs,t,uu____6219,d_lids) ->
                    (lid, bs, t, d_lids)
                | uu____6231 -> failwith "Impossible!"  in
              match uu____6194 with
              | (lid,bs,t,d_lids) ->
                  let bs1 = FStar_Syntax_Subst.subst_binders usubst bs  in
                  let t1 =
                    let uu____6255 =
                      FStar_Syntax_Subst.shift_subst (FStar_List.length bs1)
                        usubst
                       in
                    FStar_Syntax_Subst.subst uu____6255 t  in
                  let uu____6264 = FStar_Syntax_Subst.open_term bs1 t1  in
                  (match uu____6264 with
                   | (bs2,t2) ->
                       let ibs =
                         let uu____6274 =
                           let uu____6275 = FStar_Syntax_Subst.compress t2
                              in
                           uu____6275.FStar_Syntax_Syntax.n  in
                         match uu____6274 with
                         | FStar_Syntax_Syntax.Tm_arrow (ibs,uu____6279) ->
                             ibs
                         | uu____6300 -> []  in
                       let ibs1 = FStar_Syntax_Subst.open_binders ibs  in
                       let ind =
                         let uu____6309 =
                           FStar_Syntax_Syntax.fvar lid
                             FStar_Syntax_Syntax.delta_constant
                             FStar_Pervasives_Native.None
                            in
                         let uu____6310 =
                           FStar_List.map
                             (fun u  -> FStar_Syntax_Syntax.U_name u) us
                            in
                         FStar_Syntax_Syntax.mk_Tm_uinst uu____6309
                           uu____6310
                          in
                       let ind1 =
                         let uu____6316 =
                           let uu____6321 =
                             FStar_List.map
                               (fun uu____6338  ->
                                  match uu____6338 with
                                  | (bv,aq) ->
                                      let uu____6357 =
                                        FStar_Syntax_Syntax.bv_to_name bv  in
                                      (uu____6357, aq)) bs2
                              in
                           FStar_Syntax_Syntax.mk_Tm_app ind uu____6321  in
                         uu____6316 FStar_Pervasives_Native.None
                           FStar_Range.dummyRange
                          in
                       let ind2 =
                         let uu____6363 =
                           let uu____6368 =
                             FStar_List.map
                               (fun uu____6385  ->
                                  match uu____6385 with
                                  | (bv,aq) ->
                                      let uu____6404 =
                                        FStar_Syntax_Syntax.bv_to_name bv  in
                                      (uu____6404, aq)) ibs1
                              in
                           FStar_Syntax_Syntax.mk_Tm_app ind1 uu____6368  in
                         uu____6363 FStar_Pervasives_Native.None
                           FStar_Range.dummyRange
                          in
                       let haseq_ind =
                         let uu____6410 =
                           let uu____6415 =
                             let uu____6416 = FStar_Syntax_Syntax.as_arg ind2
                                in
                             [uu____6416]  in
                           FStar_Syntax_Syntax.mk_Tm_app
                             FStar_Syntax_Util.t_haseq uu____6415
                            in
                         uu____6410 FStar_Pervasives_Native.None
                           FStar_Range.dummyRange
                          in
                       let t_datas =
                         FStar_List.filter
                           (fun s  ->
                              match s.FStar_Syntax_Syntax.sigel with
                              | FStar_Syntax_Syntax.Sig_datacon
                                  (uu____6453,uu____6454,uu____6455,t_lid,uu____6457,uu____6458)
                                  -> t_lid = lid
                              | uu____6465 -> failwith "Impossible")
                           all_datas_in_the_bundle
                          in
                       let data_cond =
                         FStar_List.fold_left
                           (unoptimized_haseq_data usubst bs2 haseq_ind
                              mutuals) FStar_Syntax_Util.t_true t_datas
                          in
                       let fml = FStar_Syntax_Util.mk_imp data_cond haseq_ind
                          in
                       let fml1 =
                         let uu___913_6477 = fml  in
                         let uu____6478 =
                           let uu____6479 =
                             let uu____6486 =
                               let uu____6487 =
                                 let uu____6508 =
                                   FStar_Syntax_Syntax.binders_to_names ibs1
                                    in
                                 let uu____6513 =
                                   let uu____6526 =
                                     let uu____6537 =
                                       FStar_Syntax_Syntax.as_arg haseq_ind
                                        in
                                     [uu____6537]  in
                                   [uu____6526]  in
                                 (uu____6508, uu____6513)  in
                               FStar_Syntax_Syntax.Meta_pattern uu____6487
                                in
                             (fml, uu____6486)  in
                           FStar_Syntax_Syntax.Tm_meta uu____6479  in
                         {
                           FStar_Syntax_Syntax.n = uu____6478;
                           FStar_Syntax_Syntax.pos =
                             (uu___913_6477.FStar_Syntax_Syntax.pos);
                           FStar_Syntax_Syntax.vars =
                             (uu___913_6477.FStar_Syntax_Syntax.vars)
                         }  in
                       let fml2 =
                         FStar_List.fold_right
                           (fun b  ->
                              fun t3  ->
                                let uu____6606 =
                                  let uu____6611 =
                                    let uu____6612 =
                                      let uu____6621 =
                                        let uu____6622 =
                                          FStar_Syntax_Subst.close [b] t3  in
                                        FStar_Syntax_Util.abs
                                          [((FStar_Pervasives_Native.fst b),
                                             FStar_Pervasives_Native.None)]
                                          uu____6622
                                          FStar_Pervasives_Native.None
                                         in
                                      FStar_Syntax_Syntax.as_arg uu____6621
                                       in
                                    [uu____6612]  in
                                  FStar_Syntax_Syntax.mk_Tm_app
                                    FStar_Syntax_Util.tforall uu____6611
                                   in
                                uu____6606 FStar_Pervasives_Native.None
                                  FStar_Range.dummyRange) ibs1 fml1
                          in
                       let fml3 =
                         FStar_List.fold_right
                           (fun b  ->
                              fun t3  ->
                                let uu____6675 =
                                  let uu____6680 =
                                    let uu____6681 =
                                      let uu____6690 =
                                        let uu____6691 =
                                          FStar_Syntax_Subst.close [b] t3  in
                                        FStar_Syntax_Util.abs
                                          [((FStar_Pervasives_Native.fst b),
                                             FStar_Pervasives_Native.None)]
                                          uu____6691
                                          FStar_Pervasives_Native.None
                                         in
                                      FStar_Syntax_Syntax.as_arg uu____6690
                                       in
                                    [uu____6681]  in
                                  FStar_Syntax_Syntax.mk_Tm_app
                                    FStar_Syntax_Util.tforall uu____6680
                                   in
                                uu____6675 FStar_Pervasives_Native.None
                                  FStar_Range.dummyRange) bs2 fml2
                          in
                       FStar_Syntax_Util.mk_conj acc fml3)
  
let (unoptimized_haseq_scheme :
  FStar_Syntax_Syntax.sigelt ->
    FStar_Syntax_Syntax.sigelt Prims.list ->
      FStar_Syntax_Syntax.sigelt Prims.list ->
        FStar_TypeChecker_Env.env_t -> FStar_Syntax_Syntax.sigelt Prims.list)
  =
  fun sig_bndle  ->
    fun tcs  ->
      fun datas  ->
        fun env0  ->
          let mutuals =
            FStar_List.map
              (fun ty  ->
                 match ty.FStar_Syntax_Syntax.sigel with
                 | FStar_Syntax_Syntax.Sig_inductive_typ
                     (lid,uu____6783,uu____6784,uu____6785,uu____6786,uu____6787)
                     -> lid
                 | uu____6796 -> failwith "Impossible!") tcs
             in
          let uu____6798 =
            let ty = FStar_List.hd tcs  in
            match ty.FStar_Syntax_Syntax.sigel with
            | FStar_Syntax_Syntax.Sig_inductive_typ
                (lid,us,uu____6810,uu____6811,uu____6812,uu____6813) ->
                (lid, us)
            | uu____6822 -> failwith "Impossible!"  in
          match uu____6798 with
          | (lid,us) ->
              let uu____6832 = FStar_Syntax_Subst.univ_var_opening us  in
              (match uu____6832 with
               | (usubst,us1) ->
                   let fml =
                     FStar_List.fold_left
                       (unoptimized_haseq_ty datas mutuals usubst us1)
                       FStar_Syntax_Util.t_true tcs
                      in
                   let se =
                     let uu____6859 =
                       let uu____6860 =
                         let uu____6867 = get_haseq_axiom_lid lid  in
                         (uu____6867, us1, fml)  in
                       FStar_Syntax_Syntax.Sig_assume uu____6860  in
                     {
                       FStar_Syntax_Syntax.sigel = uu____6859;
                       FStar_Syntax_Syntax.sigrng = FStar_Range.dummyRange;
                       FStar_Syntax_Syntax.sigquals = [];
                       FStar_Syntax_Syntax.sigmeta =
                         FStar_Syntax_Syntax.default_sigmeta;
                       FStar_Syntax_Syntax.sigattrs = [];
                       FStar_Syntax_Syntax.sigopts =
                         FStar_Pervasives_Native.None
                     }  in
                   [se])
  
let (check_inductive_well_typedness :
  FStar_TypeChecker_Env.env_t ->
    FStar_Syntax_Syntax.sigelt Prims.list ->
      FStar_Syntax_Syntax.qualifier Prims.list ->
        FStar_Ident.lident Prims.list ->
          (FStar_Syntax_Syntax.sigelt * FStar_Syntax_Syntax.sigelt Prims.list
            * FStar_Syntax_Syntax.sigelt Prims.list))
  =
  fun env  ->
    fun ses  ->
      fun quals  ->
        fun lids  ->
          let uu____6921 =
            FStar_All.pipe_right ses
              (FStar_List.partition
                 (fun uu___2_6947  ->
                    match uu___2_6947 with
                    | {
                        FStar_Syntax_Syntax.sigel =
                          FStar_Syntax_Syntax.Sig_inductive_typ uu____6949;
                        FStar_Syntax_Syntax.sigrng = uu____6950;
                        FStar_Syntax_Syntax.sigquals = uu____6951;
                        FStar_Syntax_Syntax.sigmeta = uu____6952;
                        FStar_Syntax_Syntax.sigattrs = uu____6953;
                        FStar_Syntax_Syntax.sigopts = uu____6954;_} -> true
                    | uu____6978 -> false))
             in
          match uu____6921 with
          | (tys,datas) ->
              ((let uu____7001 =
                  FStar_All.pipe_right datas
                    (FStar_Util.for_some
                       (fun uu___3_7013  ->
                          match uu___3_7013 with
                          | {
                              FStar_Syntax_Syntax.sigel =
                                FStar_Syntax_Syntax.Sig_datacon uu____7015;
                              FStar_Syntax_Syntax.sigrng = uu____7016;
                              FStar_Syntax_Syntax.sigquals = uu____7017;
                              FStar_Syntax_Syntax.sigmeta = uu____7018;
                              FStar_Syntax_Syntax.sigattrs = uu____7019;
                              FStar_Syntax_Syntax.sigopts = uu____7020;_} ->
                              false
                          | uu____7043 -> true))
                   in
                if uu____7001
                then
                  let uu____7046 = FStar_TypeChecker_Env.get_range env  in
                  FStar_Errors.raise_error
                    (FStar_Errors.Fatal_NonInductiveInMutuallyDefinedType,
                      "Mutually defined type contains a non-inductive element")
                    uu____7046
                else ());
               (let univs =
                  if (FStar_List.length tys) = Prims.int_zero
                  then []
                  else
                    (let uu____7061 =
                       let uu____7062 = FStar_List.hd tys  in
                       uu____7062.FStar_Syntax_Syntax.sigel  in
                     match uu____7061 with
                     | FStar_Syntax_Syntax.Sig_inductive_typ
                         (uu____7065,uvs,uu____7067,uu____7068,uu____7069,uu____7070)
                         -> uvs
                     | uu____7079 -> failwith "Impossible, can't happen!")
                   in
                let env0 = env  in
                let uu____7084 =
                  FStar_List.fold_right
                    (fun tc  ->
                       fun uu____7123  ->
                         match uu____7123 with
                         | (env1,all_tcs,g) ->
                             let uu____7163 = tc_tycon env1 tc  in
                             (match uu____7163 with
                              | (env2,tc1,tc_u,guard) ->
                                  let g' =
                                    FStar_TypeChecker_Rel.universe_inequality
                                      FStar_Syntax_Syntax.U_zero tc_u
                                     in
                                  ((let uu____7190 =
                                      FStar_TypeChecker_Env.debug env2
                                        FStar_Options.Low
                                       in
                                    if uu____7190
                                    then
                                      let uu____7193 =
                                        FStar_Syntax_Print.sigelt_to_string
                                          tc1
                                         in
                                      FStar_Util.print1
                                        "Checked inductive: %s\n" uu____7193
                                    else ());
                                   (let uu____7198 =
                                      let uu____7199 =
                                        FStar_TypeChecker_Env.conj_guard
                                          guard g'
                                         in
                                      FStar_TypeChecker_Env.conj_guard g
                                        uu____7199
                                       in
                                    (env2, ((tc1, tc_u) :: all_tcs),
                                      uu____7198))))) tys
                    (env, [], FStar_TypeChecker_Env.trivial_guard)
                   in
                match uu____7084 with
                | (env1,tcs,g) ->
                    let uu____7245 =
                      FStar_List.fold_right
                        (fun se  ->
                           fun uu____7267  ->
                             match uu____7267 with
                             | (datas1,g1) ->
                                 let uu____7286 =
                                   let uu____7291 = tc_data env1 tcs  in
                                   uu____7291 se  in
                                 (match uu____7286 with
                                  | (data,g') ->
                                      let uu____7308 =
                                        FStar_TypeChecker_Env.conj_guard g1
                                          g'
                                         in
                                      ((data :: datas1), uu____7308))) datas
                        ([], g)
                       in
                    (match uu____7245 with
                     | (datas1,g1) ->
                         let uu____7329 =
                           let tc_universe_vars =
                             FStar_List.map FStar_Pervasives_Native.snd tcs
                              in
                           let g2 =
                             let uu___1024_7346 = g1  in
                             {
                               FStar_TypeChecker_Common.guard_f =
                                 (uu___1024_7346.FStar_TypeChecker_Common.guard_f);
                               FStar_TypeChecker_Common.deferred =
                                 (uu___1024_7346.FStar_TypeChecker_Common.deferred);
                               FStar_TypeChecker_Common.univ_ineqs =
                                 (tc_universe_vars,
                                   (FStar_Pervasives_Native.snd
                                      g1.FStar_TypeChecker_Common.univ_ineqs));
                               FStar_TypeChecker_Common.implicits =
                                 (uu___1024_7346.FStar_TypeChecker_Common.implicits)
                             }  in
                           (let uu____7356 =
                              FStar_All.pipe_left
                                (FStar_TypeChecker_Env.debug env0)
                                (FStar_Options.Other "GenUniverses")
                               in
                            if uu____7356
                            then
                              let uu____7361 =
                                FStar_TypeChecker_Rel.guard_to_string env1 g2
                                 in
                              FStar_Util.print1
                                "@@@@@@Guard before (possible) generalization: %s\n"
                                uu____7361
                            else ());
                           FStar_TypeChecker_Rel.force_trivial_guard env0 g2;
                           if (FStar_List.length univs) = Prims.int_zero
                           then generalize_and_inst_within env0 tcs datas1
                           else
                             (let uu____7380 =
                                FStar_List.map FStar_Pervasives_Native.fst
                                  tcs
                                 in
                              (uu____7380, datas1))
                            in
                         (match uu____7329 with
                          | (tcs1,datas2) ->
                              let sig_bndle =
                                let uu____7412 =
                                  FStar_TypeChecker_Env.get_range env0  in
                                let uu____7413 =
                                  FStar_List.collect
                                    (fun s  -> s.FStar_Syntax_Syntax.sigattrs)
                                    ses
                                   in
                                {
                                  FStar_Syntax_Syntax.sigel =
                                    (FStar_Syntax_Syntax.Sig_bundle
                                       ((FStar_List.append tcs1 datas2),
                                         lids));
                                  FStar_Syntax_Syntax.sigrng = uu____7412;
                                  FStar_Syntax_Syntax.sigquals = quals;
                                  FStar_Syntax_Syntax.sigmeta =
                                    FStar_Syntax_Syntax.default_sigmeta;
                                  FStar_Syntax_Syntax.sigattrs = uu____7413;
                                  FStar_Syntax_Syntax.sigopts =
                                    FStar_Pervasives_Native.None
                                }  in
                              (FStar_All.pipe_right tcs1
                                 (FStar_List.iter
                                    (fun se  ->
                                       match se.FStar_Syntax_Syntax.sigel
                                       with
                                       | FStar_Syntax_Syntax.Sig_inductive_typ
                                           (l,univs1,binders,typ,uu____7439,uu____7440)
                                           ->
                                           let fail expected inferred =
                                             let uu____7460 =
                                               let uu____7466 =
                                                 let uu____7468 =
                                                   FStar_Syntax_Print.tscheme_to_string
                                                     expected
                                                    in
                                                 let uu____7470 =
                                                   FStar_Syntax_Print.tscheme_to_string
                                                     inferred
                                                    in
                                                 FStar_Util.format2
                                                   "Expected an inductive with type %s; got %s"
                                                   uu____7468 uu____7470
                                                  in
                                               (FStar_Errors.Fatal_UnexpectedInductivetype,
                                                 uu____7466)
                                                in
                                             FStar_Errors.raise_error
                                               uu____7460
                                               se.FStar_Syntax_Syntax.sigrng
                                              in
                                           let uu____7474 =
                                             FStar_TypeChecker_Env.try_lookup_val_decl
                                               env0 l
                                              in
                                           (match uu____7474 with
                                            | FStar_Pervasives_Native.None 
                                                -> ()
                                            | FStar_Pervasives_Native.Some
                                                (expected_typ,uu____7490) ->
                                                let inferred_typ =
                                                  let body =
                                                    match binders with
                                                    | [] -> typ
                                                    | uu____7521 ->
                                                        let uu____7522 =
                                                          let uu____7529 =
                                                            let uu____7530 =
                                                              let uu____7545
                                                                =
                                                                FStar_Syntax_Syntax.mk_Total
                                                                  typ
                                                                 in
                                                              (binders,
                                                                uu____7545)
                                                               in
                                                            FStar_Syntax_Syntax.Tm_arrow
                                                              uu____7530
                                                             in
                                                          FStar_Syntax_Syntax.mk
                                                            uu____7529
                                                           in
                                                        uu____7522
                                                          FStar_Pervasives_Native.None
                                                          se.FStar_Syntax_Syntax.sigrng
                                                     in
                                                  (univs1, body)  in
                                                if
                                                  (FStar_List.length univs1)
                                                    =
                                                    (FStar_List.length
                                                       (FStar_Pervasives_Native.fst
                                                          expected_typ))
                                                then
                                                  let uu____7567 =
                                                    FStar_TypeChecker_Env.inst_tscheme
                                                      inferred_typ
                                                     in
                                                  (match uu____7567 with
                                                   | (uu____7572,inferred) ->
                                                       let uu____7574 =
                                                         FStar_TypeChecker_Env.inst_tscheme
                                                           expected_typ
                                                          in
                                                       (match uu____7574 with
                                                        | (uu____7579,expected)
                                                            ->
                                                            let uu____7581 =
                                                              FStar_TypeChecker_Rel.teq_nosmt_force
                                                                env0 inferred
                                                                expected
                                                               in
                                                            if uu____7581
                                                            then ()
                                                            else
                                                              fail
                                                                expected_typ
                                                                inferred_typ))
                                                else
                                                  fail expected_typ
                                                    inferred_typ)
                                       | uu____7588 -> ()));
                               (sig_bndle, tcs1, datas2))))))
  
let (early_prims_inductives : Prims.string Prims.list) =
  ["c_False"; "c_True"; "equals"; "h_equals"; "c_and"; "c_or"] 
let (mk_discriminator_and_indexed_projectors :
  FStar_Syntax_Syntax.qualifier Prims.list ->
    FStar_Syntax_Syntax.attribute Prims.list ->
      FStar_Syntax_Syntax.fv_qual ->
        Prims.bool ->
          FStar_TypeChecker_Env.env ->
            FStar_Ident.lident ->
              FStar_Ident.lident ->
                FStar_Syntax_Syntax.univ_names ->
                  FStar_Syntax_Syntax.binders ->
                    FStar_Syntax_Syntax.binders ->
                      FStar_Syntax_Syntax.binders ->
                        Prims.bool -> FStar_Syntax_Syntax.sigelt Prims.list)
  =
  fun iquals  ->
    fun attrs  ->
      fun fvq  ->
        fun refine_domain  ->
          fun env  ->
            fun tc  ->
              fun lid  ->
                fun uvs  ->
                  fun inductive_tps  ->
                    fun indices  ->
                      fun fields  ->
                        fun erasable  ->
                          let p = FStar_Ident.range_of_lid lid  in
                          let pos q = FStar_Syntax_Syntax.withinfo q p  in
                          let projectee ptyp =
                            FStar_Syntax_Syntax.gen_bv "projectee"
                              (FStar_Pervasives_Native.Some p) ptyp
                             in
                          let inst_univs =
                            FStar_List.map
                              (fun u  -> FStar_Syntax_Syntax.U_name u) uvs
                             in
                          let tps = inductive_tps  in
                          let arg_typ =
                            let inst_tc =
                              let uu____7715 =
                                let uu____7722 =
                                  let uu____7723 =
                                    let uu____7730 =
                                      let uu____7733 =
                                        FStar_Syntax_Syntax.lid_as_fv tc
                                          FStar_Syntax_Syntax.delta_constant
                                          FStar_Pervasives_Native.None
                                         in
                                      FStar_Syntax_Syntax.fv_to_tm uu____7733
                                       in
                                    (uu____7730, inst_univs)  in
                                  FStar_Syntax_Syntax.Tm_uinst uu____7723  in
                                FStar_Syntax_Syntax.mk uu____7722  in
                              uu____7715 FStar_Pervasives_Native.None p  in
                            let args =
                              FStar_All.pipe_right
                                (FStar_List.append tps indices)
                                (FStar_List.map
                                   (fun uu____7767  ->
                                      match uu____7767 with
                                      | (x,imp) ->
                                          let uu____7786 =
                                            FStar_Syntax_Syntax.bv_to_name x
                                             in
                                          (uu____7786, imp)))
                               in
                            FStar_Syntax_Syntax.mk_Tm_app inst_tc args
                              FStar_Pervasives_Native.None p
                             in
                          let unrefined_arg_binder =
                            let uu____7790 = projectee arg_typ  in
                            FStar_Syntax_Syntax.mk_binder uu____7790  in
                          let arg_binder =
                            if Prims.op_Negation refine_domain
                            then unrefined_arg_binder
                            else
                              (let disc_name =
                                 FStar_Syntax_Util.mk_discriminator lid  in
                               let x =
                                 FStar_Syntax_Syntax.new_bv
                                   (FStar_Pervasives_Native.Some p) arg_typ
                                  in
                               let sort =
                                 let disc_fvar =
                                   let uu____7813 =
                                     FStar_Ident.set_lid_range disc_name p
                                      in
                                   FStar_Syntax_Syntax.fvar uu____7813
                                     (FStar_Syntax_Syntax.Delta_equational_at_level
                                        Prims.int_one)
                                     FStar_Pervasives_Native.None
                                    in
                                 let uu____7815 =
                                   let uu____7818 =
                                     let uu____7821 =
                                       let uu____7826 =
                                         FStar_Syntax_Syntax.mk_Tm_uinst
                                           disc_fvar inst_univs
                                          in
                                       let uu____7827 =
                                         let uu____7828 =
                                           let uu____7837 =
                                             FStar_Syntax_Syntax.bv_to_name x
                                              in
                                           FStar_All.pipe_left
                                             FStar_Syntax_Syntax.as_arg
                                             uu____7837
                                            in
                                         [uu____7828]  in
                                       FStar_Syntax_Syntax.mk_Tm_app
                                         uu____7826 uu____7827
                                        in
                                     uu____7821 FStar_Pervasives_Native.None
                                       p
                                      in
                                   FStar_Syntax_Util.b2t uu____7818  in
                                 FStar_Syntax_Util.refine x uu____7815  in
                               let uu____7862 =
                                 let uu___1099_7863 = projectee arg_typ  in
                                 {
                                   FStar_Syntax_Syntax.ppname =
                                     (uu___1099_7863.FStar_Syntax_Syntax.ppname);
                                   FStar_Syntax_Syntax.index =
                                     (uu___1099_7863.FStar_Syntax_Syntax.index);
                                   FStar_Syntax_Syntax.sort = sort
                                 }  in
                               FStar_Syntax_Syntax.mk_binder uu____7862)
                             in
                          let ntps = FStar_List.length tps  in
                          let all_params =
                            let uu____7880 =
                              FStar_List.map
                                (fun uu____7904  ->
                                   match uu____7904 with
                                   | (x,uu____7918) ->
                                       (x,
                                         (FStar_Pervasives_Native.Some
                                            FStar_Syntax_Syntax.imp_tag)))
                                tps
                               in
                            FStar_List.append uu____7880 fields  in
                          let imp_binders =
                            FStar_All.pipe_right
                              (FStar_List.append tps indices)
                              (FStar_List.map
                                 (fun uu____7977  ->
                                    match uu____7977 with
                                    | (x,uu____7991) ->
                                        (x,
                                          (FStar_Pervasives_Native.Some
                                             FStar_Syntax_Syntax.imp_tag))))
                             in
                          let early_prims_inductive =
                            (let uu____8002 =
                               FStar_TypeChecker_Env.current_module env  in
                             FStar_Ident.lid_equals
                               FStar_Parser_Const.prims_lid uu____8002)
                              &&
                              (FStar_List.existsb
                                 (fun s  ->
                                    let uu____8008 =
                                      let uu____8010 =
                                        FStar_Ident.ident_of_lid tc  in
                                      FStar_Ident.text_of_id uu____8010  in
                                    s = uu____8008) early_prims_inductives)
                             in
                          let discriminator_ses =
                            if fvq <> FStar_Syntax_Syntax.Data_ctor
                            then []
                            else
                              (let discriminator_name =
                                 FStar_Syntax_Util.mk_discriminator lid  in
                               let no_decl = false  in
                               let only_decl =
                                 early_prims_inductive ||
                                   (let uu____8027 =
                                      let uu____8029 =
                                        FStar_TypeChecker_Env.current_module
                                          env
                                         in
                                      FStar_Ident.string_of_lid uu____8029
                                       in
                                    FStar_Options.dont_gen_projectors
                                      uu____8027)
                                  in
                               let quals =
                                 let uu____8033 =
                                   FStar_List.filter
                                     (fun uu___4_8037  ->
                                        match uu___4_8037 with
                                        | FStar_Syntax_Syntax.Abstract  ->
                                            Prims.op_Negation only_decl
                                        | FStar_Syntax_Syntax.Inline_for_extraction
                                             -> true
                                        | FStar_Syntax_Syntax.NoExtract  ->
                                            true
                                        | FStar_Syntax_Syntax.Private  ->
                                            true
                                        | uu____8042 -> false) iquals
                                    in
                                 FStar_List.append
                                   ((FStar_Syntax_Syntax.Discriminator lid)
                                   ::
                                   (if only_decl
                                    then
                                      [FStar_Syntax_Syntax.Logic;
                                      FStar_Syntax_Syntax.Assumption]
                                    else [])) uu____8033
                                  in
                               let binders =
                                 FStar_List.append imp_binders
                                   [unrefined_arg_binder]
                                  in
                               let t =
                                 let bool_typ =
                                   if erasable
                                   then
                                     FStar_Syntax_Syntax.mk_GTotal
                                       FStar_Syntax_Util.t_bool
                                   else
                                     FStar_Syntax_Syntax.mk_Total
                                       FStar_Syntax_Util.t_bool
                                    in
                                 let uu____8087 =
                                   FStar_Syntax_Util.arrow binders bool_typ
                                    in
                                 FStar_All.pipe_left
                                   (FStar_Syntax_Subst.close_univ_vars uvs)
                                   uu____8087
                                  in
                               let decl =
                                 let uu____8091 =
                                   FStar_Ident.range_of_lid
                                     discriminator_name
                                    in
                                 {
                                   FStar_Syntax_Syntax.sigel =
                                     (FStar_Syntax_Syntax.Sig_declare_typ
                                        (discriminator_name, uvs, t));
                                   FStar_Syntax_Syntax.sigrng = uu____8091;
                                   FStar_Syntax_Syntax.sigquals = quals;
                                   FStar_Syntax_Syntax.sigmeta =
                                     FStar_Syntax_Syntax.default_sigmeta;
                                   FStar_Syntax_Syntax.sigattrs = attrs;
                                   FStar_Syntax_Syntax.sigopts =
                                     FStar_Pervasives_Native.None
                                 }  in
                               (let uu____8093 =
                                  FStar_TypeChecker_Env.debug env
                                    (FStar_Options.Other "LogTypes")
                                   in
                                if uu____8093
                                then
                                  let uu____8097 =
                                    FStar_Syntax_Print.sigelt_to_string decl
                                     in
                                  FStar_Util.print1
                                    "Declaration of a discriminator %s\n"
                                    uu____8097
                                else ());
                               if only_decl
                               then [decl]
                               else
                                 (let body =
                                    if Prims.op_Negation refine_domain
                                    then FStar_Syntax_Util.exp_true_bool
                                    else
                                      (let arg_pats =
                                         FStar_All.pipe_right all_params
                                           (FStar_List.mapi
                                              (fun j  ->
                                                 fun uu____8158  ->
                                                   match uu____8158 with
                                                   | (x,imp) ->
                                                       let b =
                                                         FStar_Syntax_Syntax.is_implicit
                                                           imp
                                                          in
                                                       if b && (j < ntps)
                                                       then
                                                         let uu____8183 =
                                                           let uu____8186 =
                                                             let uu____8187 =
                                                               let uu____8194
                                                                 =
                                                                 let uu____8195
                                                                   =
                                                                   FStar_Ident.text_of_id
                                                                    x.FStar_Syntax_Syntax.ppname
                                                                    in
                                                                 FStar_Syntax_Syntax.gen_bv
                                                                   uu____8195
                                                                   FStar_Pervasives_Native.None
                                                                   FStar_Syntax_Syntax.tun
                                                                  in
                                                               (uu____8194,
                                                                 FStar_Syntax_Syntax.tun)
                                                                in
                                                             FStar_Syntax_Syntax.Pat_dot_term
                                                               uu____8187
                                                              in
                                                           pos uu____8186  in
                                                         (uu____8183, b)
                                                       else
                                                         (let uu____8204 =
                                                            let uu____8207 =
                                                              let uu____8208
                                                                =
                                                                let uu____8209
                                                                  =
                                                                  FStar_Ident.text_of_id
                                                                    x.FStar_Syntax_Syntax.ppname
                                                                   in
                                                                FStar_Syntax_Syntax.gen_bv
                                                                  uu____8209
                                                                  FStar_Pervasives_Native.None
                                                                  FStar_Syntax_Syntax.tun
                                                                 in
                                                              FStar_Syntax_Syntax.Pat_wild
                                                                uu____8208
                                                               in
                                                            pos uu____8207
                                                             in
                                                          (uu____8204, b))))
                                          in
                                       let pat_true =
                                         let uu____8229 =
                                           let uu____8232 =
                                             let uu____8233 =
                                               let uu____8247 =
                                                 FStar_Syntax_Syntax.lid_as_fv
                                                   lid
                                                   FStar_Syntax_Syntax.delta_constant
                                                   (FStar_Pervasives_Native.Some
                                                      fvq)
                                                  in
                                               (uu____8247, arg_pats)  in
                                             FStar_Syntax_Syntax.Pat_cons
                                               uu____8233
                                              in
                                           pos uu____8232  in
                                         (uu____8229,
                                           FStar_Pervasives_Native.None,
                                           FStar_Syntax_Util.exp_true_bool)
                                          in
                                       let pat_false =
                                         let uu____8282 =
                                           let uu____8285 =
                                             let uu____8286 =
                                               FStar_Syntax_Syntax.new_bv
                                                 FStar_Pervasives_Native.None
                                                 FStar_Syntax_Syntax.tun
                                                in
                                             FStar_Syntax_Syntax.Pat_wild
                                               uu____8286
                                              in
                                           pos uu____8285  in
                                         (uu____8282,
                                           FStar_Pervasives_Native.None,
                                           FStar_Syntax_Util.exp_false_bool)
                                          in
                                       let arg_exp =
                                         FStar_Syntax_Syntax.bv_to_name
                                           (FStar_Pervasives_Native.fst
                                              unrefined_arg_binder)
                                          in
                                       let uu____8300 =
                                         let uu____8307 =
                                           let uu____8308 =
                                             let uu____8331 =
                                               let uu____8348 =
                                                 FStar_Syntax_Util.branch
                                                   pat_true
                                                  in
                                               let uu____8363 =
                                                 let uu____8380 =
                                                   FStar_Syntax_Util.branch
                                                     pat_false
                                                    in
                                                 [uu____8380]  in
                                               uu____8348 :: uu____8363  in
                                             (arg_exp, uu____8331)  in
                                           FStar_Syntax_Syntax.Tm_match
                                             uu____8308
                                            in
                                         FStar_Syntax_Syntax.mk uu____8307
                                          in
                                       uu____8300
                                         FStar_Pervasives_Native.None p)
                                     in
                                  let dd =
                                    let uu____8456 =
                                      FStar_All.pipe_right quals
                                        (FStar_List.contains
                                           FStar_Syntax_Syntax.Abstract)
                                       in
                                    if uu____8456
                                    then
                                      FStar_Syntax_Syntax.Delta_abstract
                                        (FStar_Syntax_Syntax.Delta_equational_at_level
                                           Prims.int_one)
                                    else
                                      FStar_Syntax_Syntax.Delta_equational_at_level
                                        Prims.int_one
                                     in
                                  let imp =
                                    FStar_Syntax_Util.abs binders body
                                      FStar_Pervasives_Native.None
                                     in
                                  let lbtyp =
                                    if no_decl
                                    then t
                                    else FStar_Syntax_Syntax.tun  in
                                  let lb =
                                    let uu____8478 =
                                      let uu____8483 =
                                        FStar_Syntax_Syntax.lid_as_fv
                                          discriminator_name dd
                                          FStar_Pervasives_Native.None
                                         in
                                      FStar_Util.Inr uu____8483  in
                                    let uu____8484 =
                                      FStar_Syntax_Subst.close_univ_vars uvs
                                        imp
                                       in
                                    FStar_Syntax_Util.mk_letbinding
                                      uu____8478 uvs lbtyp
                                      FStar_Parser_Const.effect_Tot_lid
                                      uu____8484 [] FStar_Range.dummyRange
                                     in
                                  let impl =
                                    let uu____8490 =
                                      let uu____8491 =
                                        let uu____8498 =
                                          let uu____8501 =
                                            let uu____8502 =
                                              FStar_All.pipe_right
                                                lb.FStar_Syntax_Syntax.lbname
                                                FStar_Util.right
                                               in
                                            FStar_All.pipe_right uu____8502
                                              (fun fv  ->
                                                 (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v)
                                             in
                                          [uu____8501]  in
                                        ((false, [lb]), uu____8498)  in
                                      FStar_Syntax_Syntax.Sig_let uu____8491
                                       in
                                    {
                                      FStar_Syntax_Syntax.sigel = uu____8490;
                                      FStar_Syntax_Syntax.sigrng = p;
                                      FStar_Syntax_Syntax.sigquals = quals;
                                      FStar_Syntax_Syntax.sigmeta =
                                        FStar_Syntax_Syntax.default_sigmeta;
                                      FStar_Syntax_Syntax.sigattrs = attrs;
                                      FStar_Syntax_Syntax.sigopts =
                                        FStar_Pervasives_Native.None
                                    }  in
                                  (let uu____8516 =
                                     FStar_TypeChecker_Env.debug env
                                       (FStar_Options.Other "LogTypes")
                                      in
                                   if uu____8516
                                   then
                                     let uu____8520 =
                                       FStar_Syntax_Print.sigelt_to_string
                                         impl
                                        in
                                     FStar_Util.print1
                                       "Implementation of a discriminator %s\n"
                                       uu____8520
                                   else ());
                                  [decl; impl]))
                             in
                          let arg_exp =
                            FStar_Syntax_Syntax.bv_to_name
                              (FStar_Pervasives_Native.fst arg_binder)
                             in
                          let binders =
                            FStar_List.append imp_binders [arg_binder]  in
                          let arg =
                            FStar_Syntax_Util.arg_of_non_null_binder
                              arg_binder
                             in
                          let subst =
                            FStar_All.pipe_right fields
                              (FStar_List.mapi
                                 (fun i  ->
                                    fun uu____8591  ->
                                      match uu____8591 with
                                      | (a,uu____8600) ->
                                          let field_name =
                                            FStar_Syntax_Util.mk_field_projector_name
                                              lid a i
                                             in
                                          let field_proj_tm =
                                            let uu____8607 =
                                              let uu____8608 =
                                                FStar_Syntax_Syntax.lid_as_fv
                                                  field_name
                                                  (FStar_Syntax_Syntax.Delta_equational_at_level
                                                     Prims.int_one)
                                                  FStar_Pervasives_Native.None
                                                 in
                                              FStar_Syntax_Syntax.fv_to_tm
                                                uu____8608
                                               in
                                            FStar_Syntax_Syntax.mk_Tm_uinst
                                              uu____8607 inst_univs
                                             in
                                          let proj =
                                            FStar_Syntax_Syntax.mk_Tm_app
                                              field_proj_tm [arg]
                                              FStar_Pervasives_Native.None p
                                             in
                                          FStar_Syntax_Syntax.NT (a, proj)))
                             in
                          let projectors_ses =
                            let uu____8634 =
                              FStar_All.pipe_right fields
                                (FStar_List.mapi
                                   (fun i  ->
                                      fun uu____8674  ->
                                        match uu____8674 with
                                        | (x,uu____8685) ->
                                            let p1 =
                                              FStar_Syntax_Syntax.range_of_bv
                                                x
                                               in
                                            let field_name =
                                              FStar_Syntax_Util.mk_field_projector_name
                                                lid x i
                                               in
                                            let t =
                                              let result_comp =
                                                let t =
                                                  FStar_Syntax_Subst.subst
                                                    subst
                                                    x.FStar_Syntax_Syntax.sort
                                                   in
                                                if erasable
                                                then
                                                  FStar_Syntax_Syntax.mk_GTotal
                                                    t
                                                else
                                                  FStar_Syntax_Syntax.mk_Total
                                                    t
                                                 in
                                              let uu____8704 =
                                                FStar_Syntax_Util.arrow
                                                  binders result_comp
                                                 in
                                              FStar_All.pipe_left
                                                (FStar_Syntax_Subst.close_univ_vars
                                                   uvs) uu____8704
                                               in
                                            let only_decl =
                                              early_prims_inductive ||
                                                (let uu____8710 =
                                                   let uu____8712 =
                                                     FStar_TypeChecker_Env.current_module
                                                       env
                                                      in
                                                   FStar_Ident.string_of_lid
                                                     uu____8712
                                                    in
                                                 FStar_Options.dont_gen_projectors
                                                   uu____8710)
                                               in
                                            let no_decl = false  in
                                            let quals q =
                                              if only_decl
                                              then
                                                let uu____8731 =
                                                  FStar_List.filter
                                                    (fun uu___5_8735  ->
                                                       match uu___5_8735 with
                                                       | FStar_Syntax_Syntax.Abstract
                                                            -> false
                                                       | uu____8738 -> true)
                                                    q
                                                   in
                                                FStar_Syntax_Syntax.Assumption
                                                  :: uu____8731
                                              else q  in
                                            let quals1 =
                                              let iquals1 =
                                                FStar_All.pipe_right iquals
                                                  (FStar_List.filter
                                                     (fun uu___6_8753  ->
                                                        match uu___6_8753
                                                        with
                                                        | FStar_Syntax_Syntax.Inline_for_extraction
                                                             -> true
                                                        | FStar_Syntax_Syntax.NoExtract
                                                             -> true
                                                        | FStar_Syntax_Syntax.Abstract
                                                             -> true
                                                        | FStar_Syntax_Syntax.Private
                                                             -> true
                                                        | uu____8759 -> false))
                                                 in
                                              quals
                                                ((FStar_Syntax_Syntax.Projector
                                                    (lid,
                                                      (x.FStar_Syntax_Syntax.ppname)))
                                                :: iquals1)
                                               in
                                            let attrs1 =
                                              FStar_List.append
                                                (if only_decl
                                                 then []
                                                 else
                                                   [FStar_Syntax_Util.attr_substitute])
                                                attrs
                                               in
                                            let decl =
                                              let uu____8770 =
                                                FStar_Ident.range_of_lid
                                                  field_name
                                                 in
                                              {
                                                FStar_Syntax_Syntax.sigel =
                                                  (FStar_Syntax_Syntax.Sig_declare_typ
                                                     (field_name, uvs, t));
                                                FStar_Syntax_Syntax.sigrng =
                                                  uu____8770;
                                                FStar_Syntax_Syntax.sigquals
                                                  = quals1;
                                                FStar_Syntax_Syntax.sigmeta =
                                                  FStar_Syntax_Syntax.default_sigmeta;
                                                FStar_Syntax_Syntax.sigattrs
                                                  = attrs1;
                                                FStar_Syntax_Syntax.sigopts =
                                                  FStar_Pervasives_Native.None
                                              }  in
                                            ((let uu____8772 =
                                                FStar_TypeChecker_Env.debug
                                                  env
                                                  (FStar_Options.Other
                                                     "LogTypes")
                                                 in
                                              if uu____8772
                                              then
                                                let uu____8776 =
                                                  FStar_Syntax_Print.sigelt_to_string
                                                    decl
                                                   in
                                                FStar_Util.print1
                                                  "Declaration of a projector %s\n"
                                                  uu____8776
                                              else ());
                                             if only_decl
                                             then [decl]
                                             else
                                               (let projection =
                                                  let uu____8787 =
                                                    FStar_Ident.text_of_id
                                                      x.FStar_Syntax_Syntax.ppname
                                                     in
                                                  FStar_Syntax_Syntax.gen_bv
                                                    uu____8787
                                                    FStar_Pervasives_Native.None
                                                    FStar_Syntax_Syntax.tun
                                                   in
                                                let arg_pats =
                                                  FStar_All.pipe_right
                                                    all_params
                                                    (FStar_List.mapi
                                                       (fun j  ->
                                                          fun uu____8832  ->
                                                            match uu____8832
                                                            with
                                                            | (x1,imp) ->
                                                                let b =
                                                                  FStar_Syntax_Syntax.is_implicit
                                                                    imp
                                                                   in
                                                                if
                                                                  (i + ntps)
                                                                    = j
                                                                then
                                                                  let uu____8858
                                                                    =
                                                                    pos
                                                                    (FStar_Syntax_Syntax.Pat_var
                                                                    projection)
                                                                     in
                                                                  (uu____8858,
                                                                    b)
                                                                else
                                                                  if
                                                                    b &&
                                                                    (j < ntps)
                                                                  then
                                                                    (
                                                                    let uu____8874
                                                                    =
                                                                    let uu____8877
                                                                    =
                                                                    let uu____8878
                                                                    =
                                                                    let uu____8885
                                                                    =
                                                                    let uu____8886
                                                                    =
                                                                    FStar_Ident.text_of_id
                                                                    x1.FStar_Syntax_Syntax.ppname
                                                                     in
                                                                    FStar_Syntax_Syntax.gen_bv
                                                                    uu____8886
                                                                    FStar_Pervasives_Native.None
                                                                    FStar_Syntax_Syntax.tun
                                                                     in
                                                                    (uu____8885,
                                                                    FStar_Syntax_Syntax.tun)
                                                                     in
                                                                    FStar_Syntax_Syntax.Pat_dot_term
                                                                    uu____8878
                                                                     in
                                                                    pos
                                                                    uu____8877
                                                                     in
                                                                    (uu____8874,
                                                                    b))
                                                                  else
                                                                    (
                                                                    let uu____8895
                                                                    =
                                                                    let uu____8898
                                                                    =
                                                                    let uu____8899
                                                                    =
                                                                    let uu____8900
                                                                    =
                                                                    FStar_Ident.text_of_id
                                                                    x1.FStar_Syntax_Syntax.ppname
                                                                     in
                                                                    FStar_Syntax_Syntax.gen_bv
                                                                    uu____8900
                                                                    FStar_Pervasives_Native.None
                                                                    FStar_Syntax_Syntax.tun
                                                                     in
                                                                    FStar_Syntax_Syntax.Pat_wild
                                                                    uu____8899
                                                                     in
                                                                    pos
                                                                    uu____8898
                                                                     in
                                                                    (uu____8895,
                                                                    b))))
                                                   in
                                                let pat =
                                                  let uu____8920 =
                                                    let uu____8923 =
                                                      let uu____8924 =
                                                        let uu____8938 =
                                                          FStar_Syntax_Syntax.lid_as_fv
                                                            lid
                                                            FStar_Syntax_Syntax.delta_constant
                                                            (FStar_Pervasives_Native.Some
                                                               fvq)
                                                           in
                                                        (uu____8938,
                                                          arg_pats)
                                                         in
                                                      FStar_Syntax_Syntax.Pat_cons
                                                        uu____8924
                                                       in
                                                    pos uu____8923  in
                                                  let uu____8948 =
                                                    FStar_Syntax_Syntax.bv_to_name
                                                      projection
                                                     in
                                                  (uu____8920,
                                                    FStar_Pervasives_Native.None,
                                                    uu____8948)
                                                   in
                                                let body =
                                                  let uu____8964 =
                                                    let uu____8971 =
                                                      let uu____8972 =
                                                        let uu____8995 =
                                                          let uu____9012 =
                                                            FStar_Syntax_Util.branch
                                                              pat
                                                             in
                                                          [uu____9012]  in
                                                        (arg_exp, uu____8995)
                                                         in
                                                      FStar_Syntax_Syntax.Tm_match
                                                        uu____8972
                                                       in
                                                    FStar_Syntax_Syntax.mk
                                                      uu____8971
                                                     in
                                                  uu____8964
                                                    FStar_Pervasives_Native.None
                                                    p1
                                                   in
                                                let imp =
                                                  FStar_Syntax_Util.abs
                                                    binders body
                                                    FStar_Pervasives_Native.None
                                                   in
                                                let dd =
                                                  let uu____9077 =
                                                    FStar_All.pipe_right
                                                      quals1
                                                      (FStar_List.contains
                                                         FStar_Syntax_Syntax.Abstract)
                                                     in
                                                  if uu____9077
                                                  then
                                                    FStar_Syntax_Syntax.Delta_abstract
                                                      (FStar_Syntax_Syntax.Delta_equational_at_level
                                                         Prims.int_one)
                                                  else
                                                    FStar_Syntax_Syntax.Delta_equational_at_level
                                                      Prims.int_one
                                                   in
                                                let lbtyp =
                                                  if no_decl
                                                  then t
                                                  else
                                                    FStar_Syntax_Syntax.tun
                                                   in
                                                let lb =
                                                  let uu____9096 =
                                                    let uu____9101 =
                                                      FStar_Syntax_Syntax.lid_as_fv
                                                        field_name dd
                                                        FStar_Pervasives_Native.None
                                                       in
                                                    FStar_Util.Inr uu____9101
                                                     in
                                                  let uu____9102 =
                                                    FStar_Syntax_Subst.close_univ_vars
                                                      uvs imp
                                                     in
                                                  {
                                                    FStar_Syntax_Syntax.lbname
                                                      = uu____9096;
                                                    FStar_Syntax_Syntax.lbunivs
                                                      = uvs;
                                                    FStar_Syntax_Syntax.lbtyp
                                                      = lbtyp;
                                                    FStar_Syntax_Syntax.lbeff
                                                      =
                                                      FStar_Parser_Const.effect_Tot_lid;
                                                    FStar_Syntax_Syntax.lbdef
                                                      = uu____9102;
                                                    FStar_Syntax_Syntax.lbattrs
                                                      = [];
                                                    FStar_Syntax_Syntax.lbpos
                                                      =
                                                      FStar_Range.dummyRange
                                                  }  in
                                                let impl =
                                                  let uu____9108 =
                                                    let uu____9109 =
                                                      let uu____9116 =
                                                        let uu____9119 =
                                                          let uu____9120 =
                                                            FStar_All.pipe_right
                                                              lb.FStar_Syntax_Syntax.lbname
                                                              FStar_Util.right
                                                             in
                                                          FStar_All.pipe_right
                                                            uu____9120
                                                            (fun fv  ->
                                                               (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v)
                                                           in
                                                        [uu____9119]  in
                                                      ((false, [lb]),
                                                        uu____9116)
                                                       in
                                                    FStar_Syntax_Syntax.Sig_let
                                                      uu____9109
                                                     in
                                                  {
                                                    FStar_Syntax_Syntax.sigel
                                                      = uu____9108;
                                                    FStar_Syntax_Syntax.sigrng
                                                      = p1;
                                                    FStar_Syntax_Syntax.sigquals
                                                      = quals1;
                                                    FStar_Syntax_Syntax.sigmeta
                                                      =
                                                      FStar_Syntax_Syntax.default_sigmeta;
                                                    FStar_Syntax_Syntax.sigattrs
                                                      = attrs1;
                                                    FStar_Syntax_Syntax.sigopts
                                                      =
                                                      FStar_Pervasives_Native.None
                                                  }  in
                                                (let uu____9134 =
                                                   FStar_TypeChecker_Env.debug
                                                     env
                                                     (FStar_Options.Other
                                                        "LogTypes")
                                                    in
                                                 if uu____9134
                                                 then
                                                   let uu____9138 =
                                                     FStar_Syntax_Print.sigelt_to_string
                                                       impl
                                                      in
                                                   FStar_Util.print1
                                                     "Implementation of a projector %s\n"
                                                     uu____9138
                                                 else ());
                                                if no_decl
                                                then [impl]
                                                else [decl; impl]))))
                               in
                            FStar_All.pipe_right uu____8634
                              FStar_List.flatten
                             in
                          FStar_List.append discriminator_ses projectors_ses
  
let (mk_data_operations :
  FStar_Syntax_Syntax.qualifier Prims.list ->
    FStar_Syntax_Syntax.attribute Prims.list ->
      FStar_TypeChecker_Env.env ->
        FStar_Syntax_Syntax.sigelt Prims.list ->
          FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.sigelt Prims.list)
  =
  fun iquals  ->
    fun attrs  ->
      fun env  ->
        fun tcs  ->
          fun se  ->
            match se.FStar_Syntax_Syntax.sigel with
            | FStar_Syntax_Syntax.Sig_datacon
                (constr_lid,uvs,t,typ_lid,n_typars,uu____9201) when
                let uu____9208 =
                  FStar_Ident.lid_equals constr_lid
                    FStar_Parser_Const.lexcons_lid
                   in
                Prims.op_Negation uu____9208 ->
                let uu____9210 = FStar_Syntax_Subst.univ_var_opening uvs  in
                (match uu____9210 with
                 | (univ_opening,uvs1) ->
                     let t1 = FStar_Syntax_Subst.subst univ_opening t  in
                     let uu____9232 = FStar_Syntax_Util.arrow_formals t1  in
                     (match uu____9232 with
                      | (formals,uu____9242) ->
                          let uu____9247 =
                            let tps_opt =
                              FStar_Util.find_map tcs
                                (fun se1  ->
                                   let uu____9282 =
                                     let uu____9284 =
                                       let uu____9285 =
                                         FStar_Syntax_Util.lid_of_sigelt se1
                                          in
                                       FStar_Util.must uu____9285  in
                                     FStar_Ident.lid_equals typ_lid
                                       uu____9284
                                      in
                                   if uu____9282
                                   then
                                     match se1.FStar_Syntax_Syntax.sigel with
                                     | FStar_Syntax_Syntax.Sig_inductive_typ
                                         (uu____9307,uvs',tps,typ0,uu____9311,constrs)
                                         ->
                                         FStar_Pervasives_Native.Some
                                           (tps, typ0,
                                             ((FStar_List.length constrs) >
                                                Prims.int_one))
                                     | uu____9331 -> failwith "Impossible"
                                   else FStar_Pervasives_Native.None)
                               in
                            match tps_opt with
                            | FStar_Pervasives_Native.Some x -> x
                            | FStar_Pervasives_Native.None  ->
                                let uu____9380 =
                                  FStar_Ident.lid_equals typ_lid
                                    FStar_Parser_Const.exn_lid
                                   in
                                if uu____9380
                                then ([], FStar_Syntax_Util.ktype0, true)
                                else
                                  FStar_Errors.raise_error
                                    (FStar_Errors.Fatal_UnexpectedDataConstructor,
                                      "Unexpected data constructor")
                                    se.FStar_Syntax_Syntax.sigrng
                             in
                          (match uu____9247 with
                           | (inductive_tps,typ0,should_refine) ->
                               let inductive_tps1 =
                                 FStar_Syntax_Subst.subst_binders
                                   univ_opening inductive_tps
                                  in
                               let typ01 =
                                 FStar_Syntax_Subst.subst univ_opening typ0
                                  in
                               let uu____9418 =
                                 FStar_Syntax_Util.arrow_formals typ01  in
                               (match uu____9418 with
                                | (indices,uu____9428) ->
                                    let refine_domain =
                                      let uu____9435 =
                                        FStar_All.pipe_right
                                          se.FStar_Syntax_Syntax.sigquals
                                          (FStar_Util.for_some
                                             (fun uu___7_9442  ->
                                                match uu___7_9442 with
                                                | FStar_Syntax_Syntax.RecordConstructor
                                                    uu____9444 -> true
                                                | uu____9454 -> false))
                                         in
                                      if uu____9435
                                      then false
                                      else should_refine  in
                                    let fv_qual =
                                      let filter_records uu___8_9469 =
                                        match uu___8_9469 with
                                        | FStar_Syntax_Syntax.RecordConstructor
                                            (uu____9472,fns) ->
                                            FStar_Pervasives_Native.Some
                                              (FStar_Syntax_Syntax.Record_ctor
                                                 (typ_lid, fns))
                                        | uu____9484 ->
                                            FStar_Pervasives_Native.None
                                         in
                                      let uu____9485 =
                                        FStar_Util.find_map
                                          se.FStar_Syntax_Syntax.sigquals
                                          filter_records
                                         in
                                      match uu____9485 with
                                      | FStar_Pervasives_Native.None  ->
                                          FStar_Syntax_Syntax.Data_ctor
                                      | FStar_Pervasives_Native.Some q -> q
                                       in
                                    let iquals1 =
                                      if
                                        (FStar_List.contains
                                           FStar_Syntax_Syntax.Abstract
                                           iquals)
                                          &&
                                          (Prims.op_Negation
                                             (FStar_List.contains
                                                FStar_Syntax_Syntax.Private
                                                iquals))
                                      then FStar_Syntax_Syntax.Private ::
                                        iquals
                                      else iquals  in
                                    let fields =
                                      let uu____9498 =
                                        FStar_Util.first_N n_typars formals
                                         in
                                      match uu____9498 with
                                      | (imp_tps,fields) ->
                                          let rename =
                                            FStar_List.map2
                                              (fun uu____9581  ->
                                                 fun uu____9582  ->
                                                   match (uu____9581,
                                                           uu____9582)
                                                   with
                                                   | ((x,uu____9608),
                                                      (x',uu____9610)) ->
                                                       let uu____9631 =
                                                         let uu____9638 =
                                                           FStar_Syntax_Syntax.bv_to_name
                                                             x'
                                                            in
                                                         (x, uu____9638)  in
                                                       FStar_Syntax_Syntax.NT
                                                         uu____9631) imp_tps
                                              inductive_tps1
                                             in
                                          FStar_Syntax_Subst.subst_binders
                                            rename fields
                                       in
                                    let erasable =
                                      FStar_Syntax_Util.has_attribute
                                        se.FStar_Syntax_Syntax.sigattrs
                                        FStar_Parser_Const.erasable_attr
                                       in
                                    mk_discriminator_and_indexed_projectors
                                      iquals1 attrs fv_qual refine_domain env
                                      typ_lid constr_lid uvs1 inductive_tps1
                                      indices fields erasable))))
            | uu____9645 -> []
  