; RUN: opt -objc-arc -S < %s | FileCheck %s
; rdar://11744105
; bugzilla://14584

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.9.0"

%0 = type opaque
%struct._class_t = type { %struct._class_t*, %struct._class_t*, %struct._objc_cache*, i8* (i8*, i8*)**, %struct._class_ro_t* }
%struct._objc_cache = type opaque
%struct._class_ro_t = type { i32, i32, i32, i8*, i8*, %struct.__method_list_t*, %struct._objc_protocol_list*, %struct._ivar_list_t*, i8*, %struct._prop_list_t* }
%struct.__method_list_t = type { i32, i32, [0 x %struct._objc_method] }
%struct._objc_method = type { i8*, i8*, i8* }
%struct._objc_protocol_list = type { i64, [0 x %struct._protocol_t*] }
%struct._protocol_t = type { i8*, i8*, %struct._objc_protocol_list*, %struct.__method_list_t*, %struct.__method_list_t*, %struct.__method_list_t*, %struct.__method_list_t*, %struct._prop_list_t*, i32, i32, i8** }
%struct._prop_list_t = type { i32, i32, [0 x %struct._prop_t] }
%struct._prop_t = type { i8*, i8* }
%struct._ivar_list_t = type { i32, i32, [0 x %struct._ivar_t] }
%struct._ivar_t = type { i64*, i8*, i8*, i32, i32 }
%struct.NSConstantString = type { i32*, i32, i8*, i64 }

@"OBJC_CLASS_$_NSObject" = external global %struct._class_t
@"\01L_OBJC_CLASSLIST_REFERENCES_$_" = internal global %struct._class_t* @"OBJC_CLASS_$_NSObject", section "__DATA, __objc_classrefs, regular, no_dead_strip", align 8
@"\01L_OBJC_METH_VAR_NAME_" = internal global [4 x i8] c"new\00", section "__TEXT,__objc_methname,cstring_literals", align 1
@"\01L_OBJC_SELECTOR_REFERENCES_" = internal global i8* getelementptr inbounds ([4 x i8]* @"\01L_OBJC_METH_VAR_NAME_", i64 0, i64 0), section "__DATA, __objc_selrefs, literal_pointers, no_dead_strip"
@__CFConstantStringClassReference = external global [0 x i32]
@.str = private unnamed_addr constant [11 x i8] c"Failed: %@\00", align 1
@_unnamed_cfstring_ = private constant %struct.NSConstantString { i32* getelementptr inbounds ([0 x i32]* @__CFConstantStringClassReference, i32 0, i32 0), i32 1992, i8* getelementptr inbounds ([11 x i8]* @.str, i32 0, i32 0), i64 10 }, section "__DATA,__cfstring"
@"OBJC_CLASS_$_NSException" = external global %struct._class_t
@"\01L_OBJC_CLASSLIST_REFERENCES_$_1" = internal global %struct._class_t* @"OBJC_CLASS_$_NSException", section "__DATA, __objc_classrefs, regular, no_dead_strip", align 8
@.str2 = private unnamed_addr constant [4 x i8] c"Foo\00", align 1
@_unnamed_cfstring_3 = private constant %struct.NSConstantString { i32* getelementptr inbounds ([0 x i32]* @__CFConstantStringClassReference, i32 0, i32 0), i32 1992, i8* getelementptr inbounds ([4 x i8]* @.str2, i32 0, i32 0), i64 3 }, section "__DATA,__cfstring"
@"\01L_OBJC_METH_VAR_NAME_4" = internal global [14 x i8] c"raise:format:\00", section "__TEXT,__objc_methname,cstring_literals", align 1
@"\01L_OBJC_SELECTOR_REFERENCES_5" = internal global i8* getelementptr inbounds ([14 x i8]* @"\01L_OBJC_METH_VAR_NAME_4", i64 0, i64 0), section "__DATA, __objc_selrefs, literal_pointers, no_dead_strip"
@llvm.used = appending global [6 x i8*] [i8* bitcast (%struct._class_t** @"\01L_OBJC_CLASSLIST_REFERENCES_$_" to i8*), i8* getelementptr inbounds ([4 x i8]* @"\01L_OBJC_METH_VAR_NAME_", i32 0, i32 0), i8* bitcast (i8** @"\01L_OBJC_SELECTOR_REFERENCES_" to i8*), i8* bitcast (%struct._class_t** @"\01L_OBJC_CLASSLIST_REFERENCES_$_1" to i8*), i8* getelementptr inbounds ([14 x i8]* @"\01L_OBJC_METH_VAR_NAME_4", i32 0, i32 0), i8* bitcast (i8** @"\01L_OBJC_SELECTOR_REFERENCES_5" to i8*)], section "llvm.metadata"

define i32 @main() uwtable ssp {
entry:
  %tmp = load %struct._class_t** @"\01L_OBJC_CLASSLIST_REFERENCES_$_", align 8, !dbg !37
  %tmp1 = load i8** @"\01L_OBJC_SELECTOR_REFERENCES_", align 8, !dbg !37, !invariant.load !38
  %tmp2 = bitcast %struct._class_t* %tmp to i8*, !dbg !37
; CHECK: call i8* bitcast (i8* (i8*, i8*, ...)* @objc_msgSend to i8* (i8*, i8*)*)(i8* %tmp2, i8* %tmp1)
  %call = call i8* bitcast (i8* (i8*, i8*, ...)* @objc_msgSend to i8* (i8*, i8*)*)(i8* %tmp2, i8* %tmp1), !dbg !37, !clang.arc.no_objc_arc_exceptions !38
  call void @llvm.dbg.value(metadata !{i8* %call}, i64 0, metadata !12, metadata !{}), !dbg !37
; CHECK: call i8* @objc_retain(i8* %call) [[NUW:#[0-9]+]]
  %tmp3 = call i8* @objc_retain(i8* %call) nounwind, !dbg !39
  call void @llvm.dbg.value(metadata !{i8* %call}, i64 0, metadata !25, metadata !{}), !dbg !39
  invoke fastcc void @ThrowFunc(i8* %call)
          to label %eh.cont unwind label %lpad, !dbg !40, !clang.arc.no_objc_arc_exceptions !38

eh.cont:                                          ; preds = %entry
; CHECK: call void @objc_release(i8* %call)
  call void @objc_release(i8* %call) nounwind, !dbg !42, !clang.imprecise_release !38
  br label %if.end, !dbg !43

lpad:                                             ; preds = %entry
  %tmp4 = landingpad { i8*, i32 } personality i8* bitcast (i32 (...)* @__objc_personality_v0 to i8*)
          catch i8* null, !dbg !40
  %tmp5 = extractvalue { i8*, i32 } %tmp4, 0, !dbg !40
  %exn.adjusted = call i8* @objc_begin_catch(i8* %tmp5) nounwind, !dbg !44
  call void @llvm.dbg.value(metadata !45, i64 0, metadata !21, metadata !{}), !dbg !46
  call void @objc_end_catch(), !dbg !49, !clang.arc.no_objc_arc_exceptions !38
; CHECK: call void @objc_release(i8* %call)
  call void @objc_release(i8* %call) nounwind, !dbg !42, !clang.imprecise_release !38
  call void (i8*, ...)* @NSLog(i8* bitcast (%struct.NSConstantString* @_unnamed_cfstring_ to i8*), i8* %call), !dbg !50, !clang.arc.no_objc_arc_exceptions !38
  br label %if.end, !dbg !52

if.end:                                           ; preds = %lpad, %eh.cont
  call void (i8*, ...)* @NSLog(i8* bitcast (%struct.NSConstantString* @_unnamed_cfstring_ to i8*), i8* %call), !dbg !53, !clang.arc.no_objc_arc_exceptions !38
; CHECK: call void @objc_release(i8* %call)
  call void @objc_release(i8* %call) nounwind, !dbg !54, !clang.imprecise_release !38
  ret i32 0, !dbg !54
}

declare void @llvm.dbg.declare(metadata, metadata, metadata) nounwind readnone

declare i8* @objc_msgSend(i8*, i8*, ...) nonlazybind

declare i8* @objc_retain(i8*) nonlazybind

declare i8* @objc_begin_catch(i8*)

declare void @objc_end_catch()

declare void @objc_exception_rethrow()

define internal fastcc void @ThrowFunc(i8* %obj) uwtable noinline ssp {
entry:
  %tmp = call i8* @objc_retain(i8* %obj) nounwind
  call void @llvm.dbg.value(metadata !{i8* %obj}, i64 0, metadata !32, metadata !{}), !dbg !55
  %tmp1 = load %struct._class_t** @"\01L_OBJC_CLASSLIST_REFERENCES_$_1", align 8, !dbg !56
  %tmp2 = load i8** @"\01L_OBJC_SELECTOR_REFERENCES_5", align 8, !dbg !56, !invariant.load !38
  %tmp3 = bitcast %struct._class_t* %tmp1 to i8*, !dbg !56
  call void (i8*, i8*, %0*, %0*, ...)* bitcast (i8* (i8*, i8*, ...)* @objc_msgSend to void (i8*, i8*, %0*, %0*, ...)*)(i8* %tmp3, i8* %tmp2, %0* bitcast (%struct.NSConstantString* @_unnamed_cfstring_3 to %0*), %0* bitcast (%struct.NSConstantString* @_unnamed_cfstring_3 to %0*)), !dbg !56, !clang.arc.no_objc_arc_exceptions !38
  call void @objc_release(i8* %obj) nounwind, !dbg !58, !clang.imprecise_release !38
  ret void, !dbg !58
}

declare i32 @__objc_personality_v0(...)

declare void @objc_release(i8*) nonlazybind

declare void @NSLog(i8*, ...)

declare void @llvm.dbg.value(metadata, i64, metadata, metadata) nounwind readnone

; CHECK: attributes #0 = { ssp uwtable }
; CHECK: attributes #1 = { nounwind readnone }
; CHECK: attributes #2 = { nonlazybind }
; CHECK: attributes #3 = { noinline ssp uwtable }
; CHECK: attributes [[NUW]] = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!33, !34, !35, !36, !61}

!0 = metadata !{metadata !"0x11\0016\00clang version 3.3 \001\00\002\00\000", metadata !60, metadata !1, metadata !1, metadata !3, metadata !1, null} ; [ DW_TAG_compile_unit ] [/Volumes/Files/gottesmmcab/Radar/12906997/test.m] [DW_LANG_ObjC]
!1 = metadata !{i32 0}
!3 = metadata !{metadata !5, metadata !27}
!5 = metadata !{metadata !"0x2e\00main\00main\00\009\000\001\000\006\000\001\0010", metadata !60, metadata !6, metadata !7, null, i32 ()* @main, null, null, metadata !10} ; [ DW_TAG_subprogram ] [line 9] [def] [scope 10] [main]
!6 = metadata !{metadata !"0x29", metadata !60} ; [ DW_TAG_file_type ]
!7 = metadata !{metadata !"0x15\00\000\000\000\000\000\000", i32 0, null, null, metadata !8, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!8 = metadata !{metadata !9}
!9 = metadata !{metadata !"0x24\00int\000\0032\0032\000\000\005", null, null} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!10 = metadata !{metadata !11}
!11 = metadata !{metadata !12, metadata !21, metadata !25}
!12 = metadata !{metadata !"0x100\00obj\0011\000", metadata !13, metadata !6, metadata !14} ; [ DW_TAG_auto_variable ] [obj] [line 11]
!13 = metadata !{metadata !"0xb\0010\000\000", metadata !60, metadata !5} ; [ DW_TAG_lexical_block ] [/Volumes/Files/gottesmmcab/Radar/12906997/test.m]
!14 = metadata !{metadata !"0x16\00id\0011\000\000\000\000", metadata !60, null, metadata !15} ; [ DW_TAG_typedef ] [id] [line 11, size 0, align 0, offset 0] [from ]
!15 = metadata !{metadata !"0xf\00\000\0064\0064\000\000", metadata !60, null, metadata !16} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from objc_object]
!16 = metadata !{metadata !"0x13\00objc_object\000\000\000\000\000\000", metadata !60, null, null, metadata !17, null, i32 0, null} ; [ DW_TAG_structure_type ] [objc_object] [line 0, size 0, align 0, offset 0] [def] [from ]
!17 = metadata !{metadata !18}
!18 = metadata !{metadata !"0xd\00isa\000\0064\000\000\000", metadata !60, metadata !16, metadata !19} ; [ DW_TAG_member ] [isa] [line 0, size 64, align 0, offset 0] [from ]
!19 = metadata !{metadata !"0xf\00\000\0064\000\000\000", null, null, metadata !20} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 0, offset 0] [from objc_class]
!20 = metadata !{metadata !"0x13\00objc_class\000\000\000\000\004\000", metadata !60, null, null, null, null, null, null} ; [ DW_TAG_structure_type ] [objc_class] [line 0, size 0, align 0, offset 0] [decl] [from ]
!21 = metadata !{metadata !"0x100\00ok\0013\000", metadata !22, metadata !6, metadata !23} ; [ DW_TAG_auto_variable ] [ok] [line 13]
!22 = metadata !{metadata !"0xb\0012\000\001", metadata !60, metadata !13} ; [ DW_TAG_lexical_block ] [/Volumes/Files/gottesmmcab/Radar/12906997/test.m]
!23 = metadata !{metadata !"0x16\00BOOL\0062\000\000\000\000", metadata !60, null, metadata !24} ; [ DW_TAG_typedef ] [BOOL] [line 62, size 0, align 0, offset 0] [from signed char]
!24 = metadata !{metadata !"0x24\00signed char\000\008\008\000\000\006", null, null} ; [ DW_TAG_base_type ] [signed char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!25 = metadata !{metadata !"0x100\00obj2\0015\000", metadata !26, metadata !6, metadata !14} ; [ DW_TAG_auto_variable ] [obj2] [line 15]
!26 = metadata !{metadata !"0xb\0014\000\002", metadata !60, metadata !22} ; [ DW_TAG_lexical_block ] [/Volumes/Files/gottesmmcab/Radar/12906997/test.m]
!27 = metadata !{metadata !"0x2e\00ThrowFunc\00ThrowFunc\00\004\001\001\000\006\00256\001\005", metadata !60, metadata !6, metadata !28, null, void (i8*)* @ThrowFunc, null, null, metadata !30} ; [ DW_TAG_subprogram ] [line 4] [local] [def] [scope 5] [ThrowFunc]
!28 = metadata !{metadata !"0x15\00\000\000\000\000\000\000", i32 0, null, null, metadata !29, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!29 = metadata !{null, metadata !14}
!30 = metadata !{metadata !31}
!31 = metadata !{metadata !32}
!32 = metadata !{metadata !"0x101\00obj\0016777220\000", metadata !27, metadata !6, metadata !14} ; [ DW_TAG_arg_variable ] [obj] [line 4]
!33 = metadata !{i32 1, metadata !"Objective-C Version", i32 2}
!34 = metadata !{i32 1, metadata !"Objective-C Image Info Version", i32 0}
!35 = metadata !{i32 1, metadata !"Objective-C Image Info Section", metadata !"__DATA, __objc_imageinfo, regular, no_dead_strip"}
!36 = metadata !{i32 4, metadata !"Objective-C Garbage Collection", i32 0}
!37 = metadata !{i32 11, i32 0, metadata !13, null}
!38 = metadata !{}
!39 = metadata !{i32 15, i32 0, metadata !26, null}
!40 = metadata !{i32 17, i32 0, metadata !41, null}
!41 = metadata !{metadata !"0xb\0016\000\003", metadata !60, metadata !26} ; [ DW_TAG_lexical_block ] [/Volumes/Files/gottesmmcab/Radar/12906997/test.m]
!42 = metadata !{i32 22, i32 0, metadata !26, null}
!43 = metadata !{i32 23, i32 0, metadata !22, null}
!44 = metadata !{i32 19, i32 0, metadata !41, null}
!45 = metadata !{i8 0}
!46 = metadata !{i32 20, i32 0, metadata !47, null}
!47 = metadata !{metadata !"0xb\0019\000\005", metadata !60, metadata !48} ; [ DW_TAG_lexical_block ] [/Volumes/Files/gottesmmcab/Radar/12906997/test.m]
!48 = metadata !{metadata !"0xb\0019\000\004", metadata !60, metadata !26} ; [ DW_TAG_lexical_block ] [/Volumes/Files/gottesmmcab/Radar/12906997/test.m]
!49 = metadata !{i32 21, i32 0, metadata !47, null}
!50 = metadata !{i32 24, i32 0, metadata !51, null}
!51 = metadata !{metadata !"0xb\0023\000\006", metadata !60, metadata !22} ; [ DW_TAG_lexical_block ] [/Volumes/Files/gottesmmcab/Radar/12906997/test.m]
!52 = metadata !{i32 25, i32 0, metadata !51, null}
!53 = metadata !{i32 27, i32 0, metadata !13, null}
!54 = metadata !{i32 28, i32 0, metadata !13, null}
!55 = metadata !{i32 4, i32 0, metadata !27, null}
!56 = metadata !{i32 6, i32 0, metadata !57, null}
!57 = metadata !{metadata !"0xb\005\000\007", metadata !60, metadata !27} ; [ DW_TAG_lexical_block ] [/Volumes/Files/gottesmmcab/Radar/12906997/test.m]
!58 = metadata !{i32 7, i32 0, metadata !57, null}
!60 = metadata !{metadata !"test.m", metadata !"/Volumes/Files/gottesmmcab/Radar/12906997"}
!61 = metadata !{i32 1, metadata !"Debug Info Version", i32 2}
