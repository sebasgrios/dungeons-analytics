local _, addon = ...

local enUS = {
    help = "/da diag [start | stop | snapshot | ui | export]",
    active = "Capture is active.",
    inactive = "Capture is off.",
    started = "Diagnostic capture started.",
    stopped = "Diagnostic capture stopped.",
    alreadyActive = "Diagnostic capture is already active.",
    alreadyStopped = "Diagnostic capture is off. Use /da diag start.",
    snapshotSaved = "Diagnostic snapshot saved.",
    wrongClient = "This diagnostic targets WoW: Forever.",
    storeUnavailable = "The saved diagnostic format is unsupported. Its contents have been left intact.",
    outOfCombat = "Run this command after combat.",
    exportTitle = "Dungeons Analytics — diagnostic report",
    exportHint = "Select and copy the report text. Keep it local until reviewed.",
    uiTitle = "Dungeons Analytics — native UI probe",
    uiUnavailable = "The window is unavailable. Active captures save results in SavedVariables.",
}
local esES = {
    help = "/da diag [start | stop | snapshot | ui | export]",
    active = "La captura está activa.",
    inactive = "La captura está desactivada.",
    started = "Captura de diagnóstico iniciada.",
    stopped = "Captura de diagnóstico detenida.",
    alreadyActive = "La captura de diagnóstico ya está activa.",
    alreadyStopped = "La captura está desactivada. Usa /da diag start.",
    snapshotSaved = "Instantánea de diagnóstico guardada.",
    wrongClient = "Este diagnóstico está destinado a WoW: Forever.",
    storeUnavailable = "El formato de diagnóstico guardado no es compatible. Se ha conservado su contenido.",
    outOfCombat = "Ejecuta este comando después del combate.",
    exportTitle = "Dungeons Analytics — informe de diagnóstico",
    exportHint = "Selecciona y copia el texto del informe. Revísalo antes de compartirlo.",
    uiTitle = "Dungeons Analytics — prueba de interfaz nativa",
    uiUnavailable = "La ventana no está disponible. La captura activa guarda resultados en SavedVariables.",
}

function addon.GetMessages(locale)
    return (locale == "esES" or locale == "esMX") and esES or enUS
end
