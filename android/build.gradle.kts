import org.jetbrains.kotlin.gradle.dsl.KotlinVersion
import org.jetbrains.kotlin.gradle.tasks.KotlinCompilationTask

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// sentry_flutter 8.x still declares Kotlin language level 1.6. Kotlin 2.2
// rejects that level, so compile every Android Kotlin subproject at the
// supported 1.8 level while retaining the app's Java 17 target.
subprojects {
    tasks.withType<KotlinCompilationTask<*>>().configureEach {
        compilerOptions.languageVersion.set(KotlinVersion.KOTLIN_1_8)
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
