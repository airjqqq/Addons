local L = LibStub("AceLocale-3.0"):NewLocale("EPGP", "esMX")
if not L then return end

L["%+d EP (%s) to %s"] = "%+d EP (%s) a %s"
L["%+d GP (%s) to %s"] = "%+d GP (%s) a %s"
L["%d or %d"] = "%d o %d"
--Translation missing 
-- L["'%s' - expected 'on' or 'off', or no argument to toggle."] = ""
--Translation missing 
-- L["'%s' - expected 'on', 'off' or 'default', or no argument to toggle."] = ""
--Translation missing 
-- L["'%s' - expected 'RRGGBB' or 'r g b'."] = ""
--Translation missing 
-- L["'%s' - expected 'RRGGBBAA' or 'r g b a'."] = ""
--Translation missing 
-- L["'%s' - Invalid Keybinding."] = ""
--Translation missing 
-- L["'%s' - values must all be either in the range 0..1 or 0..255."] = ""
--Translation missing 
-- L["'%s' - values must all be either in the range 0-1 or 0-255."] = ""
--Translation missing 
-- L["'%s' '%s' - expected 'on' or 'off', or no argument to toggle."] = ""
--Translation missing 
-- L["'%s' '%s' - expected 'on', 'off' or 'default', or no argument to toggle."] = ""
L["%s is added to the award list"] = "%s se ha agregado a la lista de asignaciones"
L["%s is already in the award list"] = "%s ya esta en la lista de asignaciones"
L["%s is dead. Award EP?"] = "%s esta muerto. Asignar EP?"
L["%s is not eligible for EP awards"] = "%s no puede recibir EP"
L["%s is now removed from the award list"] = "%s se ha quitado de la lista de asignaciones"
L["%s to %s"] = "%s a %s"
L["%s: %+d EP (%s) to %s"] = "%s: %+d EP (%s) a %s"
L["%s: %+d GP (%s) to %s"] = "%s: %+d GP (%s) a %s"
L["%s: %s to %s"] = "%s: %s a %s"
L["A member is awarded EP"] = "Un miembro es recompensado con EP"
L["A member is credited GP"] = "Un miembro es acreditado con GP"
--Translation missing 
-- L["A new tier is here!  You should probably reset or rescale GP (Interface -> Options -> AddOns -> EPGP)!"] = ""
L["Alts"] = true
L["An item was disenchanted or deposited into the guild bank"] = "Un Botín fue desencantado o depositado en el Banco de la Hermandad"
L["Announce"] = "Anunciar"
--Translation missing 
-- L["Announce epic loot from corpses"] = ""
L["Announce medium"] = "Canal de Anuncio"
--Translation missing 
-- L["Announce when someone in your raid derps a bonus roll"] = ""
--Translation missing 
-- L["Announce when someone in your raid wins something good with bonus roll"] = ""
L["Announce when:"] = "Anunciar cuando:"
L["Announcement of EPGP actions"] = "Anunciar acciones sobre EPGP"
L["Announces EPGP actions to the specified medium."] = "Anunciar acciones sobre EPGP en el canal."
L["Automatic boss tracking"] = "Seguimiento de Jefe automatico"
L["Automatic boss tracking by means of a popup to mass award EP to the raid and standby when a boss is killed."] = "El seguimiento de Jefe automatico mostrara una ventana para asignar recompenzas de EP masivo a la Banda, cuando un Jefe es matado"
L["Automatic handling of the standby list through whispers when in raid. When this is enabled, the standby list is cleared after each reward."] = "Manejo automático de la lista de reserva por susurros durante un encuentro. Cuando esta activa, la lista de reserva es limpiada despues de cada recompenza"
L["Automatic loot tracking"] = "Seguimiento de despojo automatico"
L["Automatic loot tracking by means of a popup to assign GP to the toon that received loot. This option only has effect if you are in a raid and you are either the Raid Leader or the Master Looter."] = "El seguimiento de despojo automatico mostrara una ventana para asignar GP al personaje que reciba un despojo. Esta opcion solo tiene efecto si estas en Banda y eres el lider de la Banda o el Maestro despojador"
L["Award EP"] = "Otorgar EP"
L["Awards for wipes on bosses. Requires DBM, DXE, or BigWigs"] = "Recompensas por fracasar en los encuentros con jefes de banda. Requiere DBM, DXE o BigWigs."
L["Base GP should be a positive number"] = "El GP base debe ser un número positivo"
--Translation missing 
-- L["Bonus roll for %s (%s left): got %s (ilvl %d)"] = ""
--Translation missing 
-- L["Bonus roll for %s (%s left): got gold"] = ""
L["Boss"] = "Jefe"
L["Credit GP"] = "Reconocer GP"
L["Credit GP to %s"] = "Reconocer GP a %s"
L["Custom announce channel name"] = "Nombre del canal de anuncios personalizado"
L["Decay"] = "Disminución"
L["Decay EP and GP by %d%%?"] = "¿Disminuir EP y GP un %d%%?"
L["Decay of EP/GP by %d%%"] = "Disminución de EP/GP en %d%%"
L["Decay Percent should be a number between 0 and 100"] = "El porcentaje de disminución debe ser un número entre 0 y 100"
L["Decay=%s%% BaseGP=%s MinEP=%s Extras=%s%%"] = "Disminución=%s%% BaseGP=%s MinEP=%s Extras=%s%%"
--Translation missing 
-- L["default"] = ""
L["Do you want to resume recurring award (%s) %d EP/%s?"] = "Quieres reactivar la recompenza recurrente de (%s) %d EP/%s?"
L["EP Reason"] = "Razón de EP"
L["EP/GP are reset"] = "EP/GP reiniciados"
L["EPGP decay"] = true
L["EPGP is an in game, relational loot distribution system"] = "EPGP es un sistema de distribucion de items relacional dentro del juego"
L["EPGP is using Officer Notes for data storage. Do you really want to edit the Officer Note by hand?"] = "EPGP esta usando las Notas de Oficial para almacenar datos. ¿Estas seguro que deseas editar la Nota de Oficial a mano?"
L["EPGP reset"] = "Reinicio de EPGP"
--Translation missing 
-- L["expected number"] = ""
L["Export"] = "Exportar"
L["Extras Percent should be a number between 0 and 100"] = "El porcentaje extra debe ser un número de 0 a 100"
--Translation missing 
-- L["GP (not EP) is reset"] = ""
--Translation missing 
-- L["GP (not ep) reset"] = ""
--Translation missing 
-- L["GP is rescaled for the new tier"] = ""
L["GP on tooltips"] = "Valor GP en Detalles de Botin"
L["GP Reason"] = "Razón de GP"
--Translation missing 
-- L["GP rescale for new tier"] = ""
L["GP: %d"] = true
L["GP: %d or %d"] = "GP: %d o %d"
L["Guild or Raid are awarded EP"] = "Hermandad o Banda es recompensada con EP"
L["Hint: You can open these options by typing /epgp config"] = "Consejo: Puedes abrir estas opciones escribiendo /epgp config"
L["Idle"] = "Sin funcionar"
L["If you want to be on the award list but you are not in the raid, you need to whisper me: 'epgp standby' or 'epgp standby <name>' where <name> is the toon that should receive awards"] = "Si quieres estar en la lista de recompensas pero no estás en la raid, tienes que susurrarme: \"epgp standby\" o \"epgp standby <nombre>\" donde <nombre> es el personaje que debería recibir recompensas"
L["Ignoring EP change for unknown member %s"] = "Ignorar cambios de EP para miembro desconocido %s"
L["Ignoring GP change for unknown member %s"] = "Ignorar cambios en GP para miembro desconocido %s"
L["Import"] = "Importar"
L["Importing data snapshot taken at: %s"] = "Datos de importacion tomados en: %s"
--Translation missing 
-- L["invalid input"] = ""
L["Invalid officer note [%s] for %s (ignored)"] = "Nota de oficial inválida [%s] para %s"
L["List errors"] = "Listar errores"
L["Lists errors during officer note parsing to the default chat frame. Examples are members with an invalid officer note."] = "Listar errores durante el análisis de las notas al marco de chat por defecto. Por ejemplo los miembros con una nota de oficial inválida."
L["Loot"] = "Botín"
L["Loot tracking threshold"] = "Seguimiento de Botín mínimo"
--Translation missing 
-- L["Main"] = ""
L["Make sure you are the only person changing EP and GP. If you have multiple people changing EP and GP at the same time, for example one awarding EP and another crediting GP, you *are* going to have data loss."] = "Asegurate que eres la unica persona cambiando el EP y GP. Si multiples personas cambian el EP y GP al mismo tiempo, for ejemplo una recompensa EP y otra acreditando GP, tu *vas* a tener perdida de datos."
L["Mass EP Award"] = "Otorgar EP masivo"
L["Min EP should be a positive number"] = "EP Mínimo debe ser un número positivo"
--Translation missing 
-- L["must be equal to or higher than %s"] = ""
--Translation missing 
-- L["must be equal to or lower than %s"] = ""
L["Next award in "] = "Siguiente recompensa en"
--Translation missing 
-- L["off"] = ""
--Translation missing 
-- L["on"] = ""
L["Only display GP values for items at or above this quality."] = "Solo mostrar valores de GP para Botines iguales o encima de esta calidad."
L["Open the configuration options"] = "Abrir las opciones de configuracion"
L["Open the debug window"] = "Abir la ventana de depuracion"
L["Other"] = "Otro"
--Translation missing 
-- L["Outsiders should be 0 or 1"] = ""
L["Paste import data here"] = "Pegar los datos importados aqui"
L["Personal Action Log"] = "Registro personal de acciones"
L["Provide a proposed GP value of armor on tooltips. Quest items or tokens that can be traded for armor will also have a proposed GP value."] = "Provee un valor GP propuesto y lo muestra en tooltips. Los botines de quest o insignia también recibirán un valor GP propuesto"
L["Quality threshold"] = "Calidad Mínima"
L["Recurring"] = "Recurrente"
L["Recurring awards resume"] = "Recompensas recurrentes reiniciadas"
L["Recurring awards start"] = "Recompensas recurrentes iniciadas"
L["Recurring awards stop"] = "Recompensas recurrentes detenidas"
L["Redo"] = "Rehacer"
--Translation missing 
-- L["Re-scale all main toons' GP to current tier?"] = ""
--Translation missing 
-- L["Rescale GP"] = ""
--Translation missing 
-- L["Rescale GP of all members of the guild. This will reduce all main toons' GP by a tier worth of value. Use with care!"] = ""
L["Reset all main toons' EP and GP to 0?"] = "¿Reiniciar todo el EP y GP de los personajes principales a 0?"
--Translation missing 
-- L["Reset all main toons' GP to 0?"] = ""
L["Reset EPGP"] = "Reiniciar EPGP"
--Translation missing 
-- L["Reset only GP"] = ""
L["Resets EP and GP of all members of the guild. This will set all main toons' EP and GP to 0. Use with care!"] = "einicia el EP y GP de todos los miembros de la hermandad. Esto pondrá todo el EP y GP de los personajes principales a 0. ¡Usar con precaución!"
--Translation missing 
-- L["Resets GP (not EP!) of all members of the guild. This will set all main toons' GP to 0. Use with care!"] = ""
L["Resume recurring award (%s) %d EP/%s"] = "Reactivar la recompensa de (%s) %d EP/%s"
L["Sets loot tracking threshold, to disable the popup on loot below this threshold quality."] = "Seleccionar seguimiento de Botín mínimo, para desactivar esta ventana en Botines con menor calidad a la elegida"
L["Sets the announce medium EPGP will use to announce EPGP actions."] = "Configura el medio para anuncios que EPGP utilizará para anunciar las acciones de EPGP"
L["Sets the custom announce channel name used to announce EPGP actions."] = "Configura el nombre canal de anuncios personalizado utilizado para anunciar las acciones de EPGP"
L["Show everyone"] = "Mostrar a todos"
--Translation missing 
-- L["Some english word"] = ""
--Translation missing 
-- L["Some english word that doesn't exist"] = ""
L["Standby"] = "En espera"
L["Standby whispers in raid"] = "Susurro de las reservas durante un encuentro de Banda"
L["Start recurring award (%s) %d EP/%s"] = "Comienzo de recompensa recurrente (%s) %d EP/%s"
L["Stop recurring award"] = "Fin de recomensa recurrente"
--Translation missing 
-- L["string1"] = ""
L["The imported data is invalid"] = "Los datos importados son inválidos"
L["To export the current standings, copy the text below and post it to: %s"] = "Para exportar los datos conocidos, copiar el texto debajo y péguelo en: %s"
L["To restore to an earlier version of the standings, copy and paste the text from: %s"] = "Para restaurar una versión mas reciente de los datos, copie y pegue el texto desde: %s"
L["Tooltip"] = "Detalles en Botín"
L["Undo"] = "Deshacer"
--Translation missing 
-- L["unknown argument"] = ""
--Translation missing 
-- L["unknown selection"] = ""
L["Using %s for boss kill tracking"] = "Use %s para mantener el seguimiento en las muertes de un boss"
L["Value"] = "Valor"
L["Whisper"] = "Susurrar"
L["Wipe awards"] = "Recompensas por fallos"
L["Wiped on %s. Award EP?"] = "Fallo en %s. Recompensar con EP?"
L["You can now check your epgp standings and loot on the web: http://www.epgpweb.com"] = "Tu puedes ahora verificar tu EPGP y Botines en la web: http://www.epgpweb.com"
