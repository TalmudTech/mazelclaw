package ai.mazelclaw.android.ui

import androidx.compose.runtime.Composable
import ai.mazelclaw.android.MainViewModel
import ai.mazelclaw.android.ui.chat.ChatSheetContent

@Composable
fun ChatSheet(viewModel: MainViewModel) {
  ChatSheetContent(viewModel = viewModel)
}
