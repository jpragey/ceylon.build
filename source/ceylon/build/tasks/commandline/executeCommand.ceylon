import ceylon.build.task { Context, Task, Outcome, Failure, done }
import ceylon.process {
    Process, createProcess,
    Input, currentInput,
    Output, currentOutput,
    Error, currentError,
    currentEnvironment
}
import ceylon.file { current, Path }

"Returns a `Task` that will run the given command in a new a new process using [[executeCommand]].
 Returns true if process exit code is `0`, false otherwise."
see(`function executeCommand`)
shared Task command(
        "The _command_ to be run in the new
         process, usually a program with a list
         of its arguments."
        String|[String+] command,
        "The directory in which the process runs."
        Path path = current,
        "The source for the standard input stream
         of the process, or `null` if the standard
         input should be piped from the current
         process."
        Input? input = currentInput,
        "The destination for the standard output
         stream ofthe process, or `null` if the
         standard output should be piped to the
         current process."
        Output? output = currentOutput,
        "The destination for the standard output
         stream ofthe process, or `null` if the
         standard error should be piped to the
         current process."
        Error? error = currentError,
        "Environment variables to pass to the
         process. By default the process inherits
         the environment variables of the current
         virtual machine process."
        {<String->String>*} environment = currentEnvironment) {
    return function(Context context) {
        Integer exitCode = executeCommand(command, path, currentInput, currentOutput, currentError, environment) else 0;
        return exitCodeToOutcome(exitCode, command, path);
    };
}

"Creates and starts a new process, running the given command.
 Waits for process termination and returns its exit code."
see(`function createProcess`)
shared Integer? executeCommand(
        "The _command_ to be run in the new
         process, usually a program with a list
         of its arguments."
        String|[String+] command,
        "The directory in which the process runs."
        Path path = current,
        "The source for the standard input stream
         of the process, or `null` if the standard
         input should be piped from the current
         process."
        Input? input = currentInput,
        "The destination for the standard output
         stream ofthe process, or `null` if the
         standard output should be piped to the
         current process."
        Output? output = currentOutput,
        "The destination for the standard output
         stream ofthe process, or `null` if the
         standard error should be piped to the
         current process."
        Error? error = currentError,
        "Environment variables to pass to the
         process. By default the process inherits
         the environment variables of the current
         virtual machine process."
        {<String->String>*} environment = currentEnvironment) {
    String commandToRun;
    switch (command)
    case (is String){
        commandToRun = command.trimmed;
    } case (is [String+]) {
        // FIXME this is a workaround while waiting for createProcess to accept `String|[String+]`
        // FIXME https://github.com/ceylon/ceylon-sdk/issues/172
        commandToRun = " ".join(command).trimmed;
    }
    Process process = createProcess(commandToRun, path, input, output, error, *environment);
    process.waitForExit();
    return process.exitCode;
}

"Convert a command exit code into an Outcome.
 
 If `exitCode` is `0`, a successfull outcome will be returned.
 
 If `exitCode` is not `0`, a failure outcome will be returned with information about executed command."
shared Outcome exitCodeToOutcome(Integer exitCode, String|[String+] command, Path path = current) {
    if (exitCode == 0) {
        return done;
    } else {
        return Failure(
                "command:            ``command``\n" +
                "working directory:  ``path``\n" +
                "exits with code:    ``exitCode``");
    }
}
