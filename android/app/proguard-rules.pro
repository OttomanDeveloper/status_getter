# ---------------------------------------------------------------------------
# Room — generated *_Impl database classes are instantiated via reflection.
# Without these, R8 strips WorkDatabase_Impl and the app crashes on launch:
#   "Failed to create an instance of androidx.work.impl.WorkDatabase"
# ---------------------------------------------------------------------------
-keep class * extends androidx.room.RoomDatabase { <init>(); }
-keep class **_Impl { <init>(...); }
-keepclassmembers class * extends androidx.room.RoomDatabase {
    public <init>(...);
}
-dontwarn androidx.room.**

# ---------------------------------------------------------------------------
# WorkManager — pulled in transitively by flutter_file_downloader. Auto-inits
# at startup through androidx.startup.InitializationProvider.
# ---------------------------------------------------------------------------
-keep class androidx.work.** { *; }
-keep class * extends androidx.work.Worker { <init>(...); }
-keep class * extends androidx.work.ListenableWorker { <init>(...); }
-keep class * extends androidx.work.InputMerger { <init>(...); }
-dontwarn androidx.work.**

# ---------------------------------------------------------------------------
# androidx.startup — runs WorkManager's initializer at process start.
# ---------------------------------------------------------------------------
-keep class androidx.startup.** { *; }
-keep class * extends androidx.startup.Initializer { <init>(...); }
