hw.module @Memory(%RADDR: i5, %CLK: i1, %WADDR: i5, %WDATA_x: i1, %WDATA_y: i7, %WE: i1) -> (RDATA_x: i1, RDATA_y: i7) {
    %0 = comb.extract %WDATA_y from 0 : (i7) -> i1
    %1 = comb.extract %WDATA_y from 1 : (i7) -> i1
    %2 = comb.extract %WDATA_y from 2 : (i7) -> i1
    %3 = comb.extract %WDATA_y from 3 : (i7) -> i1
    %4 = comb.extract %WDATA_y from 4 : (i7) -> i1
    %5 = comb.extract %WDATA_y from 5 : (i7) -> i1
    %6 = comb.extract %WDATA_y from 6 : (i7) -> i1
    %7 = comb.concat %6, %5, %4, %3, %2, %1, %0, %WDATA_x : i1, i1, i1, i1, i1, i1, i1, i1
    %9 = sv.reg {name = "coreir_mem32x8_inst0"} : !hw.inout<!hw.array<32xi8>>
    %10 = sv.array_index_inout %9[%RADDR] : !hw.inout<!hw.array<32xi8>>, i5
    %8 = sv.read_inout %10 : !hw.inout<i8>
    %11 = sv.array_index_inout %9[%WADDR] : !hw.inout<!hw.array<32xi8>>, i5
    sv.alwaysff(posedge %CLK) {
        sv.if %WE {
            sv.passign %11, %7 : i8
        }
    }
    %12 = comb.extract %8 from 0 : (i8) -> i1
    %13 = comb.extract %8 from 1 : (i8) -> i1
    %14 = comb.extract %8 from 2 : (i8) -> i1
    %15 = comb.extract %8 from 3 : (i8) -> i1
    %16 = comb.extract %8 from 4 : (i8) -> i1
    %17 = comb.extract %8 from 5 : (i8) -> i1
    %18 = comb.extract %8 from 6 : (i8) -> i1
    %19 = comb.extract %8 from 7 : (i8) -> i1
    %20 = comb.concat %19, %18, %17, %16, %15, %14, %13 : i1, i1, i1, i1, i1, i1, i1
    hw.output %12, %20 : i1, i7
}
hw.module @test_when_memory_Tuplex_Bit_y_Bits7(%data0_x: i1, %data0_y: i7, %addr0: i5, %en0: i1, %data1_x: i1, %data1_y: i7, %addr1: i5, %en1: i1, %CLK: i1) -> (out_x: i1, out_y: i7) {
    %0 = comb.extract %addr0 from 0 : (i5) -> i1
    %1 = comb.extract %addr0 from 1 : (i5) -> i1
    %2 = comb.extract %addr0 from 2 : (i5) -> i1
    %3 = comb.extract %addr0 from 3 : (i5) -> i1
    %4 = comb.extract %addr0 from 4 : (i5) -> i1
    %5 = comb.extract %data0_y from 0 : (i7) -> i1
    %6 = comb.extract %data0_y from 1 : (i7) -> i1
    %7 = comb.extract %data0_y from 2 : (i7) -> i1
    %8 = comb.extract %data0_y from 3 : (i7) -> i1
    %9 = comb.extract %data0_y from 4 : (i7) -> i1
    %10 = comb.extract %data0_y from 5 : (i7) -> i1
    %11 = comb.extract %data0_y from 6 : (i7) -> i1
    %12 = hw.constant 1 : i1
    %13 = comb.extract %addr1 from 0 : (i5) -> i1
    %14 = comb.extract %addr1 from 1 : (i5) -> i1
    %15 = comb.extract %addr1 from 2 : (i5) -> i1
    %16 = comb.extract %addr1 from 3 : (i5) -> i1
    %17 = comb.extract %addr1 from 4 : (i5) -> i1
    %23 = comb.concat %22, %21, %20, %19, %18 : i1, i1, i1, i1, i1
    %29 = comb.concat %28, %27, %26, %25, %24 : i1, i1, i1, i1, i1
    %37 = comb.concat %36, %35, %34, %33, %32, %31, %30 : i1, i1, i1, i1, i1, i1, i1
    %40, %41 = hw.instance "Memory_inst0" @Memory(RADDR: %23: i5, CLK: %CLK: i1, WADDR: %29: i5, WDATA_x: %38: i1, WDATA_y: %37: i7, WE: %39: i1) -> (RDATA_x: i1, RDATA_y: i7)
    %42 = comb.extract %41 from 0 : (i7) -> i1
    %43 = comb.extract %41 from 1 : (i7) -> i1
    %44 = comb.extract %41 from 2 : (i7) -> i1
    %45 = comb.extract %41 from 3 : (i7) -> i1
    %46 = comb.extract %41 from 4 : (i7) -> i1
    %47 = comb.extract %41 from 5 : (i7) -> i1
    %48 = comb.extract %41 from 6 : (i7) -> i1
    %49 = comb.extract %data1_y from 0 : (i7) -> i1
    %50 = comb.extract %data1_y from 1 : (i7) -> i1
    %51 = comb.extract %data1_y from 2 : (i7) -> i1
    %52 = comb.extract %data1_y from 3 : (i7) -> i1
    %53 = comb.extract %data1_y from 4 : (i7) -> i1
    %54 = comb.extract %data1_y from 5 : (i7) -> i1
    %55 = comb.extract %data1_y from 6 : (i7) -> i1
    %56 = hw.constant 0 : i1
    %65 = sv.reg : !hw.inout<i1>
    %24 = sv.read_inout %65 : !hw.inout<i1>
    %66 = sv.reg : !hw.inout<i1>
    %25 = sv.read_inout %66 : !hw.inout<i1>
    %67 = sv.reg : !hw.inout<i1>
    %26 = sv.read_inout %67 : !hw.inout<i1>
    %68 = sv.reg : !hw.inout<i1>
    %27 = sv.read_inout %68 : !hw.inout<i1>
    %69 = sv.reg : !hw.inout<i1>
    %28 = sv.read_inout %69 : !hw.inout<i1>
    %70 = sv.reg : !hw.inout<i1>
    %38 = sv.read_inout %70 : !hw.inout<i1>
    %71 = sv.reg : !hw.inout<i1>
    %30 = sv.read_inout %71 : !hw.inout<i1>
    %72 = sv.reg : !hw.inout<i1>
    %31 = sv.read_inout %72 : !hw.inout<i1>
    %73 = sv.reg : !hw.inout<i1>
    %32 = sv.read_inout %73 : !hw.inout<i1>
    %74 = sv.reg : !hw.inout<i1>
    %33 = sv.read_inout %74 : !hw.inout<i1>
    %75 = sv.reg : !hw.inout<i1>
    %34 = sv.read_inout %75 : !hw.inout<i1>
    %76 = sv.reg : !hw.inout<i1>
    %35 = sv.read_inout %76 : !hw.inout<i1>
    %77 = sv.reg : !hw.inout<i1>
    %36 = sv.read_inout %77 : !hw.inout<i1>
    %78 = sv.reg : !hw.inout<i1>
    %39 = sv.read_inout %78 : !hw.inout<i1>
    %79 = sv.reg : !hw.inout<i1>
    %18 = sv.read_inout %79 : !hw.inout<i1>
    %80 = sv.reg : !hw.inout<i1>
    %19 = sv.read_inout %80 : !hw.inout<i1>
    %81 = sv.reg : !hw.inout<i1>
    %20 = sv.read_inout %81 : !hw.inout<i1>
    %82 = sv.reg : !hw.inout<i1>
    %21 = sv.read_inout %82 : !hw.inout<i1>
    %83 = sv.reg : !hw.inout<i1>
    %22 = sv.read_inout %83 : !hw.inout<i1>
    %84 = sv.reg : !hw.inout<i1>
    %57 = sv.read_inout %84 : !hw.inout<i1>
    %85 = sv.reg : !hw.inout<i1>
    %58 = sv.read_inout %85 : !hw.inout<i1>
    %86 = sv.reg : !hw.inout<i1>
    %59 = sv.read_inout %86 : !hw.inout<i1>
    %87 = sv.reg : !hw.inout<i1>
    %60 = sv.read_inout %87 : !hw.inout<i1>
    %88 = sv.reg : !hw.inout<i1>
    %61 = sv.read_inout %88 : !hw.inout<i1>
    %89 = sv.reg : !hw.inout<i1>
    %62 = sv.read_inout %89 : !hw.inout<i1>
    %90 = sv.reg : !hw.inout<i1>
    %63 = sv.read_inout %90 : !hw.inout<i1>
    %91 = sv.reg : !hw.inout<i1>
    %64 = sv.read_inout %91 : !hw.inout<i1>
    sv.alwayscomb {
        sv.bpassign %65, %56 : i1
        sv.bpassign %66, %56 : i1
        sv.bpassign %67, %56 : i1
        sv.bpassign %68, %56 : i1
        sv.bpassign %69, %56 : i1
        sv.bpassign %70, %56 : i1
        sv.bpassign %71, %56 : i1
        sv.bpassign %72, %56 : i1
        sv.bpassign %73, %56 : i1
        sv.bpassign %74, %56 : i1
        sv.bpassign %75, %56 : i1
        sv.bpassign %76, %56 : i1
        sv.bpassign %77, %56 : i1
        sv.bpassign %78, %56 : i1
        sv.bpassign %79, %56 : i1
        sv.bpassign %80, %56 : i1
        sv.bpassign %81, %56 : i1
        sv.bpassign %82, %56 : i1
        sv.bpassign %83, %56 : i1
        sv.if %en0 {
            sv.bpassign %65, %0 : i1
            sv.bpassign %66, %1 : i1
            sv.bpassign %67, %2 : i1
            sv.bpassign %68, %3 : i1
            sv.bpassign %69, %4 : i1
            sv.bpassign %70, %data0_x : i1
            sv.bpassign %71, %5 : i1
            sv.bpassign %72, %6 : i1
            sv.bpassign %73, %7 : i1
            sv.bpassign %74, %8 : i1
            sv.bpassign %75, %9 : i1
            sv.bpassign %76, %10 : i1
            sv.bpassign %77, %11 : i1
            sv.bpassign %78, %12 : i1
            sv.bpassign %79, %13 : i1
            sv.bpassign %80, %14 : i1
            sv.bpassign %81, %15 : i1
            sv.bpassign %82, %16 : i1
            sv.bpassign %83, %17 : i1
            sv.bpassign %84, %40 : i1
            sv.bpassign %85, %42 : i1
            sv.bpassign %86, %43 : i1
            sv.bpassign %87, %44 : i1
            sv.bpassign %88, %45 : i1
            sv.bpassign %89, %46 : i1
            sv.bpassign %90, %47 : i1
            sv.bpassign %91, %48 : i1
        } else {
            sv.if %en1 {
                sv.bpassign %65, %13 : i1
                sv.bpassign %66, %14 : i1
                sv.bpassign %67, %15 : i1
                sv.bpassign %68, %16 : i1
                sv.bpassign %69, %17 : i1
                sv.bpassign %70, %data1_x : i1
                sv.bpassign %71, %49 : i1
                sv.bpassign %72, %50 : i1
                sv.bpassign %73, %51 : i1
                sv.bpassign %74, %52 : i1
                sv.bpassign %75, %53 : i1
                sv.bpassign %76, %54 : i1
                sv.bpassign %77, %55 : i1
                sv.bpassign %78, %12 : i1
                sv.bpassign %79, %0 : i1
                sv.bpassign %80, %1 : i1
                sv.bpassign %81, %2 : i1
                sv.bpassign %82, %3 : i1
                sv.bpassign %83, %4 : i1
                sv.bpassign %84, %40 : i1
                sv.bpassign %85, %42 : i1
                sv.bpassign %86, %43 : i1
                sv.bpassign %87, %44 : i1
                sv.bpassign %88, %45 : i1
                sv.bpassign %89, %46 : i1
                sv.bpassign %90, %47 : i1
                sv.bpassign %91, %48 : i1
            } else {
                sv.bpassign %84, %12 : i1
                sv.bpassign %85, %12 : i1
                sv.bpassign %86, %12 : i1
                sv.bpassign %87, %12 : i1
                sv.bpassign %88, %12 : i1
                sv.bpassign %89, %12 : i1
                sv.bpassign %90, %12 : i1
                sv.bpassign %91, %12 : i1
            }
        }
    }
    %92 = comb.concat %64, %63, %62, %61, %60, %59, %58 : i1, i1, i1, i1, i1, i1, i1
    hw.output %57, %92 : i1, i7
}
