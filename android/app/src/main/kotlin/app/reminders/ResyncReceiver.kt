package app.reminders

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import dev.fluttercommunity.workmanager.BackgroundWorker

class ResyncReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val work = OneTimeWorkRequestBuilder<BackgroundWorker>()
            .setInputData(Data.Builder().putString(BackgroundWorker.DART_TASK_KEY, "syncAlarms").build())
            .build()
        WorkManager.getInstance(context).enqueueUniqueWork("system-alarm-sync", ExistingWorkPolicy.REPLACE, work)
    }
}
