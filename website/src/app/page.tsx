import Link from "next/link";
import Image from "next/image";

export default function Home() {
  return (
    <div className="min-h-screen bg-[oklch(0.985_0.002_250)]">
      {/* Header */}
      <header className="container mx-auto px-6 py-6">
        <nav className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Image
              src="/app-icon.png"
              alt="PuppyPro"
              width={48}
              height={48}
              className="rounded-xl shadow-md"
            />
            <span className="text-xl font-bold text-[oklch(0.15_0.01_250)]">PuppyPro</span>
          </div>
          <div className="flex items-center gap-6">
            <Link href="/privacy" className="text-[oklch(0.55_0.01_250)] hover:text-[oklch(0.55_0.15_165)] transition font-medium">
              Privacy
            </Link>
            <Link href="/terms" className="text-[oklch(0.55_0.01_250)] hover:text-[oklch(0.55_0.15_165)] transition font-medium">
              Terms
            </Link>
            <Link href="/support" className="text-[oklch(0.55_0.01_250)] hover:text-[oklch(0.55_0.15_165)] transition font-medium">
              Support
            </Link>
          </div>
        </nav>
      </header>

      {/* Hero Section */}
      <main className="container mx-auto px-6">
        <section className="py-20 text-center">
          <div className="max-w-3xl mx-auto">
            <div className="inline-flex items-center gap-2 bg-[oklch(0.55_0.15_165/0.1)] text-[oklch(0.55_0.15_165)] px-5 py-2.5 rounded-full text-sm font-semibold mb-8">
              <Image src="/icons/lightning.png" alt="" width={18} height={18} />
              Now available on the App Store
            </div>

            <h1 className="text-5xl md:text-6xl font-bold text-[oklch(0.15_0.01_250)] leading-tight mb-6">
              Train Smarter,<br />
              <span className="text-[oklch(0.55_0.15_165)]">Not Harder</span>
            </h1>

            <p className="text-xl text-[oklch(0.55_0.01_250)] mb-10 max-w-2xl mx-auto leading-relaxed">
              Transform your pup into a well-behaved companion with proven positive
              reinforcement techniques. Track progress, build habits, and celebrate every win.
            </p>

            {/* App Store Button */}
            <a
              href="https://apps.apple.com/app/puppypro"
              className="inline-flex items-center gap-3 bg-[oklch(0.15_0.01_250)] text-white px-8 py-4 rounded-full hover:bg-[oklch(0.25_0.01_250)] transition shadow-lg hover:shadow-xl"
            >
              <svg className="w-8 h-8" viewBox="0 0 24 24" fill="currentColor">
                <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
              </svg>
              <div className="text-left">
                <div className="text-xs opacity-80">Download on the</div>
                <div className="text-lg font-semibold">App Store</div>
              </div>
            </a>
          </div>

          {/* App Preview Card */}
          <div className="mt-16 relative">
            <div className="absolute inset-0 bg-gradient-to-b from-[oklch(0.55_0.15_165/0.2)] to-transparent rounded-3xl blur-3xl"></div>
            <div className="relative bg-white rounded-3xl shadow-xl p-8 max-w-md mx-auto border border-[oklch(0.92_0.004_250)]">
              <div className="space-y-6">
                <div className="flex items-center gap-4">
                  <div className="w-16 h-16 bg-[oklch(0.55_0.15_165/0.1)] rounded-2xl flex items-center justify-center p-3">
                    <Image src="/icons/target_clicker.png" alt="Clicker" width={40} height={40} />
                  </div>
                  <div className="text-left">
                    <h3 className="font-semibold text-[oklch(0.15_0.01_250)]">Precision Training</h3>
                    <p className="text-sm text-[oklch(0.55_0.01_250)]">Perfect timing with our clicker</p>
                  </div>
                </div>
                <div className="flex items-center gap-4">
                  <div className="w-16 h-16 bg-[oklch(0.65_0.18_145/0.1)] rounded-2xl flex items-center justify-center p-3">
                    <Image src="/icons/tabprogress.png" alt="Progress" width={40} height={40} />
                  </div>
                  <div className="text-left">
                    <h3 className="font-semibold text-[oklch(0.15_0.01_250)]">Track Progress</h3>
                    <p className="text-sm text-[oklch(0.55_0.01_250)]">See your pup improve daily</p>
                  </div>
                </div>
                <div className="flex items-center gap-4">
                  <div className="w-16 h-16 bg-[oklch(0.75_0.14_55/0.15)] rounded-2xl flex items-center justify-center p-3">
                    <Image src="/icons/bell.png" alt="Reminders" width={40} height={40} />
                  </div>
                  <div className="text-left">
                    <h3 className="font-semibold text-[oklch(0.15_0.01_250)]">Smart Reminders</h3>
                    <p className="text-sm text-[oklch(0.55_0.01_250)]">Never miss a training session</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Features Section */}
        <section className="py-20">
          <h2 className="text-3xl font-bold text-center text-[oklch(0.15_0.01_250)] mb-12">
            Everything You Need to Train Your Pup
          </h2>

          <div className="grid md:grid-cols-3 gap-8 max-w-5xl mx-auto">
            <div className="bg-white p-8 rounded-2xl shadow-lg border border-[oklch(0.92_0.004_250)]">
              <div className="w-16 h-16 bg-[oklch(0.55_0.15_165/0.1)] rounded-xl flex items-center justify-center mb-5 p-3">
                <Image src="/icons/target_clicker.png" alt="Clicker" width={40} height={40} />
              </div>
              <h3 className="text-xl font-bold text-[oklch(0.15_0.01_250)] mb-3">Precision Clicker</h3>
              <p className="text-[oklch(0.55_0.01_250)] leading-relaxed">
                Mark the exact moment your dog gets it right with our responsive training clicker.
              </p>
            </div>

            <div className="bg-white p-8 rounded-2xl shadow-lg border border-[oklch(0.92_0.004_250)]">
              <div className="w-16 h-16 bg-[oklch(0.65_0.18_145/0.1)] rounded-xl flex items-center justify-center mb-5 p-3">
                <Image src="/icons/tabcommands.png" alt="Commands" width={40} height={40} />
              </div>
              <h3 className="text-xl font-bold text-[oklch(0.15_0.01_250)] mb-3">Command Library</h3>
              <p className="text-[oklch(0.55_0.01_250)] leading-relaxed">
                From basic sits to advanced tricks, we&apos;ve got step-by-step guides for every command.
              </p>
            </div>

            <div className="bg-white p-8 rounded-2xl shadow-lg border border-[oklch(0.92_0.004_250)]">
              <div className="w-16 h-16 bg-[oklch(0.75_0.14_55/0.15)] rounded-xl flex items-center justify-center mb-5 p-3">
                <Image src="/icons/fire_streak.png" alt="Streak" width={40} height={40} />
              </div>
              <h3 className="text-xl font-bold text-[oklch(0.15_0.01_250)] mb-3">Streak Tracking</h3>
              <p className="text-[oklch(0.55_0.01_250)] leading-relaxed">
                Stay motivated with daily streaks and celebrate your training consistency.
              </p>
            </div>
          </div>
        </section>
      </main>

      {/* Footer */}
      <footer className="border-t border-[oklch(0.92_0.004_250)] bg-white">
        <div className="container mx-auto px-6 py-12">
          <div className="flex flex-col md:flex-row items-center justify-between gap-6">
            <div className="flex items-center gap-3">
              <Image
                src="/app-icon.png"
                alt="PuppyPro"
                width={40}
                height={40}
                className="rounded-xl"
              />
              <span className="font-bold text-[oklch(0.15_0.01_250)]">PuppyPro</span>
            </div>

            <div className="flex items-center gap-6 text-sm text-[oklch(0.55_0.01_250)]">
              <Link href="/privacy" className="hover:text-[oklch(0.55_0.15_165)] transition">
                Privacy Policy
              </Link>
              <Link href="/terms" className="hover:text-[oklch(0.55_0.15_165)] transition">
                Terms of Use
              </Link>
              <Link href="/support" className="hover:text-[oklch(0.55_0.15_165)] transition">
                Support
              </Link>
            </div>

            <p className="text-sm text-[oklch(0.55_0.01_250)]">
              © {new Date().getFullYear()} PuppyPro. All rights reserved.
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}
