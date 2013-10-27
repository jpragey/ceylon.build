import ceylon.test { assertEquals, test }
import ceylon.build.tasks.ceylon { buildCompileJsCommand }

test void shouldCreateCompileJsCommand() {
    assertEquals{
        expected = "ceylon compile-js mymodule";
        actual = buildCompileJsCommand {
            ceylon = "ceylon";
            currentWorkingDirectory = null;
            compilationUnits = ["mymodule"];
            encoding = null;
            sourceDirectories = [];
            outputRepository = null;
            repositories = [];
            systemRepository = null;
            cacheRepository = null;
            user = null;
            password = null;
            offline = false;
            compact = false;
            noComments = false;
            noIndent = false;
            noModule = false;
            optimize = false;
            profile = false;
            skipSourceArchive = false;
            verbose = false;
            arguments = [];
        };
    };
}

test void shouldCreateCompileJsCommandWithAllParametersSpecified() {
    assertEquals{
        expected = "./ceylon compile-js --cwd=. --encoding=UTF-8 --source=source-a --source=source-b" +
                " --out=~/.ceylon/repo --rep=dependencies1 --rep=dependencies2 --sysrep=system-repository" +
                " --cacherep=cache-rep --user=ceylon-user --pass=ceylon-user-password --offline --compact" +
                " --no-comments --no-indent --no-module --optimize --profile" +
                " --skip-src-archive --verbose --source=foo --source=bar mymodule file1.js file2.js";
        actual = buildCompileJsCommand {
            ceylon = "./ceylon";
            currentWorkingDirectory = ".";
            compilationUnits = ["mymodule", "file1.js", "file2.js"];
            encoding = "UTF-8";
            sourceDirectories = ["source-a", "source-b"];
            outputRepository = "~/.ceylon/repo";
            repositories = ["dependencies1", "dependencies2"];
            systemRepository = "system-repository";
            cacheRepository = "cache-rep";
            user = "ceylon-user";
            password = "ceylon-user-password";
            offline = true;
            compact = true;
            noComments = true;
            noIndent = true;
            noModule = true;
            optimize = true;
            profile = true;
            skipSourceArchive = true;
            verbose = true;
            arguments = ["--source=foo", "--source=bar"];
        };
    };
}
