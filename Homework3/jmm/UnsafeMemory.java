// class UnsafeMemory {
//     public static void main(String args[]) {
// 	if (args.length != 5)
// 	    usage(null);
// 	try {
// 	    boolean virtual;
// 	    if (args[0].equals("Platform"))
// 		virtual = false;
// 	    else if (args[0].equals("Virtual"))
// 		virtual = true;
// 	    else
// 		throw new Exception(args[0]);

// 	    var nValues = (int) argInt(args[1], 0, Integer.MAX_VALUE);

// 	    State s;
// 	    if (args[2].equals("Null"))
// 		s = new NullState(nValues);
// 	    else if (args[2].equals("Synchronized"))
// 		s = new SynchronizedState(nValues);
// 	    else if (args[2].equals("Unsynchronized"))
// 	    	s = new UnsynchronizedState(nValues);
// 	    // else if (args[2].equals("AcmeSafe"))
// 	    // 	s = new AcmeSafeState(nValues);
// 	    else
// 		throw new Exception(args[2]);

// 	    var nThreads = (int) argInt(args[3], 1, Integer.MAX_VALUE);
// 	    var nTransitions = argInt(args[4], 0, Long.MAX_VALUE);

// 	    dowork(virtual, nThreads, nTransitions, s);
// 	    test(s.current());
// 	    System.exit(0);
// 	} catch (Exception e) {
// 	    usage(e);
// 	}
//     }

//     private static void usage(Exception e) {
// 	if (e != null)
// 	    System.err.println(e);
// 	System.err.println("Arguments: [Platform|Virtual] nvalues model"
// 			   + " nthreads ntransitions\n");
// 	System.exit(1);
//     }

//     private static long argInt(String s, long min, long max) {
// 	var n = Long.parseLong(s);
// 	if (min <= n && n <= max)
// 	    return n;
// 	throw new NumberFormatException(s);
//     }

//     private static void dowork(boolean virtual, int nThreads,
// 			       long nTransitions, State s)
//       throws InterruptedException {
// 	var builder = virtual ? Thread.ofVirtual() : Thread.ofPlatform();
// 	var test = new SwapTest[nThreads];
// 	var t = new Thread[nThreads];
// 	for (var i = 0; i < nThreads; i++) {
// 	    var threadTransitions =
// 		(nTransitions / nThreads
// 		 + (i < nTransitions % nThreads ? 1 : 0));
// 	    test[i] = new SwapTest(threadTransitions, s);
// 	    t[i] = builder.unstarted(test[i]);
// 	}
// 	var realtimeStart = System.nanoTime();
// 	for (var i = 0; i < nThreads; i++)
// 	    t[i].start();
// 	for (var i = 0; i < nThreads; i++)
// 	    t[i].join();
// 	var realtimeEnd = System.nanoTime();
// 	long realtime = realtimeEnd - realtimeStart;
// 	double dTransitions = nTransitions;
// 	System.out.format("Total real time %g s\n",
// 			  realtime / 1e9);
// 	System.out.format("Average real swap time %g ns\n",
// 			  realtime / dTransitions * nThreads);
//     }

//     private static void test(long[] output) {
// 	long osum = 0;
// 	for (var i = 0; i < output.length; i++)
// 	    osum += output[i];
// 	if (osum != 0)
// 	    error("output sum mismatch", osum, 0);
//     }

//     private static void error(String s, long i, long j) {
// 	System.err.format("%s (%d != %d)\n", s, i, j);
// 	System.exit(1);
//     }
// }


public class UnsafeMemory {
    public static void main(String[] args) throws Exception {
        if (args.length == 1 && args[0].equalsIgnoreCase("ALL")) {
            runAllTests();
            return;
        }
        usage(null);
    }

    private static void runAllTests() throws Exception {
        String[] states       = { "Null", "Synchronized", "Unsynchronized" };
        String[] models       = { "Platform", "Virtual" };
        int[]    sizes        = { 5, 100 };
        int[]    threadCounts = { 1, 8, 40 };
        long     transitions  = 100_000_000L;

        // CSV header
        System.out.println(
          "State,ThreadModel,Size,Threads,TotalTime_s,AvgSwap_ns,SumAfter");

        for (var stateName : states) {
            for (var modelName : models) {
                boolean virtual = modelName.equals("Virtual");
                for (var size : sizes) {
                    for (var nThreads : threadCounts) {
                        State s = createState(stateName, size);
                        var result = measure(virtual, nThreads, transitions, s);
                        double totalSec = result.totalNs / 1e9;
                        double avgNs     = (double) result.totalNs / transitions * nThreads;
                        long   sumAfter  = result.sumAfter;

                        // one CSV line per configuration
                        System.out.format(
                          "%s,%s,%d,%d,%.6f,%.3f,%d%n",
                          stateName, modelName,
                          size, nThreads,
                          totalSec, avgNs, sumAfter);
                    }
                }
            }
        }
    }

    private static record Result(long totalNs, long sumAfter) {}

    private static Result measure(boolean virtual,
                                  int nThreads,
                                  long nTransitions,
                                  State s)
        throws InterruptedException
    {
        var builder = virtual
                    ? Thread.ofVirtual().factory()
                    : Thread.ofPlatform().factory();

        Thread[] threads = new Thread[nThreads];
        long[]   parts   = new long[nThreads];
        for (int i = 0; i < nThreads; i++) {
            long chunk = nTransitions / nThreads
                       + (i < (nTransitions % nThreads) ? 1 : 0);
            parts[i] = chunk;
            threads[i] = builder.newThread(new SwapTest(chunk, s));
        }

        long t0 = System.nanoTime();
        for (var t : threads) t.start();
        for (var t : threads) t.join();
        long t1 = System.nanoTime();

        // instead of exit-on-error, we just compute the sum
        long sum = 0;
        for (long v : s.current()) sum += v;

        return new Result(t1 - t0, sum);
    }

    private static State createState(String name, int nValues) {
        return switch (name) {
          case "Null"           -> new NullState(nValues);
          case "Synchronized"   -> new SynchronizedState(nValues);
          case "Unsynchronized" -> new UnsynchronizedState(nValues);
          default -> throw new IllegalArgumentException(name);
        };
    }

    private static void usage(Exception e) {
        if (e != null) System.err.println(e.getMessage());
        System.err.println("Usage: ALL    (to run every test)\n" +
                           "   or: Platform|Virtual  nValues  StateName  nThreads  nTrans");
        System.exit(1);
    }
}
