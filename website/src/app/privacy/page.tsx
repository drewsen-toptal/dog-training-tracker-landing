import Link from "next/link";

export const metadata = {
  title: "Privacy Policy - PuppyPro",
  description: "Privacy Policy for PuppyPro dog training app",
};

export default function PrivacyPolicy() {
  return (
    <div className="min-h-screen bg-[#FFFBF8]">
      {/* Header */}
      <header className="container mx-auto px-6 py-6">
        <nav className="flex items-center justify-between">
          <Link href="/" className="flex items-center gap-2">
            <div className="w-10 h-10 bg-[#FF6F3C] rounded-xl flex items-center justify-center">
              <span className="text-white text-xl">🐕</span>
            </div>
            <span className="text-xl font-bold text-[#2D3436]">PuppyPro</span>
          </Link>
          <div className="flex items-center gap-6">
            <Link href="/terms" className="text-[#636e72] hover:text-[#2D3436] transition">
              Terms
            </Link>
            <Link href="/support" className="text-[#636e72] hover:text-[#2D3436] transition">
              Support
            </Link>
          </div>
        </nav>
      </header>

      {/* Content */}
      <main className="container mx-auto px-6 py-12 max-w-3xl">
        <h1 className="text-4xl font-bold text-[#2D3436] mb-8">Privacy Policy</h1>
        <p className="text-[#636e72] mb-8">Last updated: December 30, 2024</p>

        <div className="prose prose-lg text-[#2D3436] space-y-6">
          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Introduction</h2>
            <p className="text-[#636e72] leading-relaxed">
              PuppyPro ("we", "our", or "us") is committed to protecting your privacy. This Privacy
              Policy explains how we collect, use, and safeguard your information when you use our
              mobile application.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Information We Collect</h2>
            <p className="text-[#636e72] leading-relaxed mb-4">
              We collect minimal information to provide you with the best dog training experience:
            </p>
            <ul className="list-disc pl-6 text-[#636e72] space-y-2">
              <li><strong>Dog Information:</strong> Your dog's name, breed, and birth date that you voluntarily provide</li>
              <li><strong>Training Data:</strong> Training sessions, progress, and command mastery levels</li>
              <li><strong>App Preferences:</strong> Settings like notification preferences and daily goals</li>
            </ul>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">How We Use Your Information</h2>
            <p className="text-[#636e72] leading-relaxed mb-4">We use the information we collect to:</p>
            <ul className="list-disc pl-6 text-[#636e72] space-y-2">
              <li>Personalize your training experience</li>
              <li>Track your dog's training progress</li>
              <li>Send training reminders (if enabled)</li>
              <li>Sync your data across your devices via iCloud (optional)</li>
            </ul>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Data Storage</h2>
            <p className="text-[#636e72] leading-relaxed">
              All your data is stored locally on your device using Apple's secure frameworks. If
              you enable iCloud sync, your data is stored in your private iCloud container, which
              is encrypted and accessible only by you. We do not have access to your iCloud data.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Third-Party Services</h2>
            <p className="text-[#636e72] leading-relaxed">
              PuppyPro does not share your personal information with third parties. We do not use
              any third-party analytics or advertising services. Your data stays on your device
              and in your iCloud account.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">In-App Purchases</h2>
            <p className="text-[#636e72] leading-relaxed">
              Purchase transactions are processed by Apple. We do not collect or store any payment
              information. All purchase records are managed through your Apple ID.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Children's Privacy</h2>
            <p className="text-[#636e72] leading-relaxed">
              PuppyPro does not knowingly collect personal information from children under 13. The
              app is designed for dog owners of all ages to train their pets.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Your Rights</h2>
            <p className="text-[#636e72] leading-relaxed mb-4">You have the right to:</p>
            <ul className="list-disc pl-6 text-[#636e72] space-y-2">
              <li>Access your data within the app</li>
              <li>Delete all your data by deleting the app</li>
              <li>Disable iCloud sync at any time</li>
              <li>Manage notification permissions through iOS Settings</li>
            </ul>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Changes to This Policy</h2>
            <p className="text-[#636e72] leading-relaxed">
              We may update this Privacy Policy from time to time. We will notify you of any
              changes by posting the new Privacy Policy on this page and updating the "Last
              updated" date.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Contact Us</h2>
            <p className="text-[#636e72] leading-relaxed">
              If you have any questions about this Privacy Policy, please contact us at{" "}
              <a href="mailto:support@puppypro.app" className="text-[#FF6F3C] hover:underline">
                support@puppypro.app
              </a>
            </p>
          </section>
        </div>
      </main>

      {/* Footer */}
      <footer className="border-t border-gray-200 bg-white mt-12">
        <div className="container mx-auto px-6 py-8">
          <div className="flex flex-col md:flex-row items-center justify-between gap-4">
            <Link href="/" className="flex items-center gap-2">
              <div className="w-8 h-8 bg-[#FF6F3C] rounded-lg flex items-center justify-center">
                <span className="text-white text-sm">🐕</span>
              </div>
              <span className="font-bold text-[#2D3436]">PuppyPro</span>
            </Link>
            <p className="text-sm text-[#636e72]">
              © {new Date().getFullYear()} PuppyPro. All rights reserved.
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}
