class UnsafeMemory {
    public static void main(String args[]) {
	if (args.length != 5)
	    usage(null);
	try {
	    boolean virtual;
	    if (args[0].equals("Platform"))
		virtual = false;
	    else if (args[0].equals("Virtual"))
		virtual = true;
	    else
		throw new Exception(args[0]);

	    var nValues = (int) argInt(args[1], 0, Integer.MAX_VALUE);

	    State s;
	    if (args[2].equals("Null"))
		s = new NullState(nValues);
	    else if (args[2].equals("Synchronized"))
		s = new SynchronizedState(nValues);
	    else if (args[2].equals("Unsynchronized"))
	    	s = new UnsynchronizedState(nValues);
	    // else if (args[2].equals("AcmeSafe"))
	    // 	s = new AcmeSafeState(nValues);
	    else
		throw new Exception(args[2]);

	    var nThreads = (int) argInt(args[3], 1, Integer.MAX_VALUE);
	    var nTransitions = argInt(args[4], 0, Long.MAX_VALUE);

	    dowork(virtual, nThreads, nTransitions, s);
	    test(s.current());
	    System.exit(0);
	} catch (Exception e) {
	    usage(e);
	}
    }

    private static void usage(Exception e) {
	if (e != null)
	    System.err.println(e);
	System.err.println("Arguments: [Platform|Virtual] nvalues model"
			   + " nthreads ntransitions\n");
	System.exit(1);
    }

    private static long argInt(String s, long min, long max) {
	var n = Long.parseLong(s);
	if (min <= n && n <= max)
	    return n;
	throw new NumberFormatException(s);
    }

    private static void dowork(boolean virtual, int nThreads,
			       long nTransitions, State s)
      throws InterruptedException {
	var builder = virtual ? Thread.ofVirtual() : Thread.ofPlatform();
	var test = new SwapTest[nThreads];
	var t = new Thread[nThreads];
	for (var i = 0; i < nThreads; i++) {
	    var threadTransitions =
		(nTransitions / nThreads
		 + (i < nTransitions % nThreads ? 1 : 0));
	    test[i] = new SwapTest(threadTransitions, s);
	    t[i] = builder.unstarted(test[i]);
	}
	var realtimeStart = System.nanoTime();
	for (var i = 0; i < nThreads; i++)
	    t[i].start();
	for (var i = 0; i < nThreads; i++)
	    t[i].join();
	var realtimeEnd = System.nanoTime();
	long realtime = realtimeEnd - realtimeStart;
	double dTransitions = nTransitions;
	System.out.format("Total real time %g s\n",
			  realtime / 1e9);
	System.out.format("Average real swap time %g ns\n",
			  realtime / dTransitions * nThreads);
    }

    private static void test(long[] output) {
	long osum = 0;
	for (var i = 0; i < output.length; i++)
	    osum += output[i];
	if (osum != 0)
	    error("output sum mismatch", osum, 0);
    }

    private static void error(String s, long i, long j) {
	System.err.format("%s (%d != %d)\n", s, i, j);
	System.exit(1);
    }
}

// import java.util.concurrent.ThreadLocalRandom;

// /**
//  * Automated harness for measuring and reporting performance and reliability
//  * across all combinations of State implementations, thread models, array sizes,
//  * and thread counts. Each configuration is averaged over three trials.
//  */
// public class UnsafeMemory {
//     private static final String[] STATES       = { "Null", "Synchronized", "Unsynchronized" };
//     private static final String[] MODELS       = { "Platform", "Virtual" };
//     private static final int[]    SIZES        = { 5, 100 };
//     private static final int[]    THREAD_COUNTS = { 1, 8, 40 };
//     private static final long     TRANSITIONS  = 100_000_000L;
//     private static final int      TRIALS       = 3;

//     public static void main(String[] args) throws InterruptedException {
//         // CSV header
//         System.out.println("State,ThreadModel,Size,Threads,AvgTotalTime_s,AvgSwap_ns,AvgAbsSumErr");

//         for (var stateName : STATES) {
//             for (var modelName : MODELS) {
//                 boolean virtual = modelName.equals("Virtual");
//                 for (var size : SIZES) {
//                     for (var nThreads : THREAD_COUNTS) {
//                         long sumTotalNs = 0;
//                         long sumAbsErr  = 0;

//                         // Repeat trials and accumulate
//                         for (int t = 0; t < TRIALS; t++) {
//                             State s = createState(stateName, size);
//                             Result r = measureTrial(virtual, nThreads, TRANSITIONS, s);
//                             sumTotalNs += r.totalNs();
//                             sumAbsErr  += r.absSum();
//                         }

//                         double avgTotalNs  = (double) sumTotalNs / TRIALS;
//                         double avgSwapNs   = avgTotalNs / TRANSITIONS * nThreads;
//                         double avgTotalS   = avgTotalNs / 1e9;
//                         double avgAbsError = (double) sumAbsErr / TRIALS;

//                         System.out.printf(
//                           "%s,%s,%d,%d,%.6f,%.3f,%.1f%n",
//                           stateName,
//                           modelName,
//                           size,
//                           nThreads,
//                           avgTotalS,
//                           avgSwapNs,
//                           avgAbsError
//                         );
//                     }
//                 }
//             }
//         }
//     }

//     /**
//      * Measure one trial: run the swap test, return elapsed ns and absolute sum error.
//      */
//     private static Result measureTrial(
//         boolean virtual,
//         int nThreads,
//         long nTransitions,
//         State s
//     ) throws InterruptedException {
//         // Choose thread builder
//         Thread.Builder builder = virtual
//             ? Thread.ofVirtual()
//             : Thread.ofPlatform();

//         // Divide transitions among threads
//         Thread[] threads = new Thread[nThreads];
//         for (int i = 0; i < nThreads; i++) {
//             long chunk = nTransitions / nThreads
//                        + (i < (nTransitions % nThreads) ? 1 : 0);
//             threads[i] = builder.unstarted(new SwapTest(chunk, s));
//         }

//         // Time the parallel run
//         long t0 = System.nanoTime();
//         for (var th : threads) th.start();
//         for (var th : threads) th.join();
//         long t1 = System.nanoTime();

//         long totalNs = t1 - t0;

//         // Compute absolute sum error
//         long sum = 0;
//         for (var v : s.current()) sum += v;
//         long absSum = Math.abs(sum);

//         return new Result(totalNs, absSum);
//     }

//     /**
//      * Factory for State implementations by name.
//      */
//     private static State createState(String name, int size) {
//         return switch (name) {
//             case "Null"           -> new NullState(size);
//             case "Synchronized"   -> new SynchronizedState(size);
//             case "Unsynchronized" -> new UnsynchronizedState(size);
//             default -> throw new IllegalArgumentException(name);
//         };
//     }

//     /**
//      * Holds results of a single trial: total elapsed nanoseconds and abs error.
//      */
//     private record Result(long totalNs, long absSum) {}
// }
