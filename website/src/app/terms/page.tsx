import Link from "next/link";

export const metadata = {
  title: "Terms of Use - PuppyPro",
  description: "Terms of Use for PuppyPro dog training app",
};

export default function TermsOfUse() {
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
            <Link href="/privacy" className="text-[#636e72] hover:text-[#2D3436] transition">
              Privacy
            </Link>
            <Link href="/support" className="text-[#636e72] hover:text-[#2D3436] transition">
              Support
            </Link>
          </div>
        </nav>
      </header>

      {/* Content */}
      <main className="container mx-auto px-6 py-12 max-w-3xl">
        <h1 className="text-4xl font-bold text-[#2D3436] mb-8">Terms of Use</h1>
        <p className="text-[#636e72] mb-8">Last updated: December 30, 2024</p>

        <div className="prose prose-lg text-[#2D3436] space-y-6">
          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Agreement to Terms</h2>
            <p className="text-[#636e72] leading-relaxed">
              By downloading, installing, or using PuppyPro ("the App"), you agree to be bound by
              these Terms of Use. If you do not agree to these terms, please do not use the App.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">License</h2>
            <p className="text-[#636e72] leading-relaxed">
              We grant you a limited, non-exclusive, non-transferable, revocable license to use
              the App for personal, non-commercial purposes on devices you own or control, subject
              to these Terms and Apple's App Store Terms of Service.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">App Purpose</h2>
            <p className="text-[#636e72] leading-relaxed">
              PuppyPro is designed to assist dog owners in training their pets using positive
              reinforcement techniques. The App provides training guides, a clicker tool, progress
              tracking, and reminder features to support your training journey.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Training Disclaimer</h2>
            <p className="text-[#636e72] leading-relaxed">
              The training information provided in PuppyPro is for educational purposes only. Every
              dog is different, and training results may vary. We recommend consulting with a
              professional dog trainer or veterinarian for specific behavioral issues. PuppyPro is
              not a substitute for professional dog training advice.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">In-App Purchases</h2>
            <p className="text-[#636e72] leading-relaxed mb-4">
              PuppyPro offers optional in-app purchases that provide additional features:
            </p>
            <ul className="list-disc pl-6 text-[#636e72] space-y-2">
              <li>All purchases are processed through Apple and subject to Apple's payment policies</li>
              <li>Purchases are non-refundable except as required by applicable law or Apple's policies</li>
              <li>Purchased features are tied to your Apple ID and can be restored on any device signed into the same Apple ID</li>
            </ul>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">User Responsibilities</h2>
            <p className="text-[#636e72] leading-relaxed mb-4">By using the App, you agree to:</p>
            <ul className="list-disc pl-6 text-[#636e72] space-y-2">
              <li>Use the App only for its intended purpose of dog training assistance</li>
              <li>Not attempt to reverse engineer, modify, or distribute the App</li>
              <li>Not use the App in any way that violates applicable laws</li>
              <li>Take responsibility for your dog's training and safety</li>
            </ul>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Intellectual Property</h2>
            <p className="text-[#636e72] leading-relaxed">
              All content in the App, including but not limited to text, graphics, logos, icons,
              images, and software, is the property of PuppyPro and is protected by copyright and
              other intellectual property laws.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Limitation of Liability</h2>
            <p className="text-[#636e72] leading-relaxed">
              To the maximum extent permitted by law, PuppyPro and its developers shall not be
              liable for any indirect, incidental, special, consequential, or punitive damages
              arising from your use of the App, including but not limited to any injuries to you
              or your pet during training activities.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Termination</h2>
            <p className="text-[#636e72] leading-relaxed">
              We reserve the right to terminate or suspend your access to the App at any time,
              without notice, for conduct that we believe violates these Terms or is harmful to
              other users, us, or third parties.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Changes to Terms</h2>
            <p className="text-[#636e72] leading-relaxed">
              We may update these Terms of Use from time to time. Continued use of the App after
              any changes constitutes your acceptance of the new Terms.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Governing Law</h2>
            <p className="text-[#636e72] leading-relaxed">
              These Terms shall be governed by and construed in accordance with the laws of the
              United States, without regard to conflict of law principles.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-[#2D3436] mt-8 mb-4">Contact Us</h2>
            <p className="text-[#636e72] leading-relaxed">
              If you have any questions about these Terms of Use, please contact us at{" "}
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
