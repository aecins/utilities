function clearAllPreserveBreakpoints()
current_breakpoints = dbstatus('-completenames');
evalin('base', 'clear all');
dbstop(current_breakpoints );
end