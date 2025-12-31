import Link from "next/link";

export const metadata = {
  title: "Support - PuppyPro",
  description: "Get help with PuppyPro dog training app",
};

export default function Support() {
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
            <Link href="/terms" className="text-[#636e72] hover:text-[#2D3436] transition">
              Terms
            </Link>
          </div>
        </nav>
      </header>

      {/* Content */}
      <main className="container mx-auto px-6 py-12 max-w-3xl">
        <div className="text-center mb-12">
          <div className="w-20 h-20 bg-[#FF6F3C]/10 rounded-2xl flex items-center justify-center mx-auto mb-6">
            <span className="text-4xl">💬</span>
          </div>
          <h1 className="text-4xl font-bold text-[#2D3436] mb-4">How Can We Help?</h1>
          <p className="text-xl text-[#636e72]">
            We're here to help you and your pup succeed!
          </p>
        </div>

        <div className="space-y-8">
          {/* Contact Card */}
          <div className="bg-white p-8 rounded-2xl shadow-lg">
            <h2 className="text-2xl font-bold text-[#2D3436] mb-4">Contact Support</h2>
            <p className="text-[#636e72] mb-6">
              Have a question, feedback, or need help with something? We'd love to hear from you!
            </p>
            <a
              href="mailto:support@puppypro.app"
              className="inline-flex items-center gap-3 bg-[#FF6F3C] text-white px-6 py-3 rounded-xl hover:bg-[#E55A2B] transition"
            >
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
              </svg>
              support@puppypro.app
            </a>
          </div>

          {/* FAQ Section */}
          <div className="bg-white p-8 rounded-2xl shadow-lg">
            <h2 className="text-2xl font-bold text-[#2D3436] mb-6">Frequently Asked Questions</h2>

            <div className="space-y-6">
              <div>
                <h3 className="font-bold text-[#2D3436] mb-2">How do I restore my purchases?</h3>
                <p className="text-[#636e72]">
                  Go to Settings in the app and tap "Restore Purchases". Make sure you're signed
                  into the same Apple ID you used for the original purchase.
                </p>
              </div>

              <div>
                <h3 className="font-bold text-[#2D3436] mb-2">How does iCloud sync work?</h3>
                <p className="text-[#636e72]">
                  If you have iCloud enabled on your device, PuppyPro will automatically sync your
                  training data across all your devices signed into the same Apple ID.
                </p>
              </div>

              <div>
                <h3 className="font-bold text-[#2D3436] mb-2">Can I train multiple dogs?</h3>
                <p className="text-[#636e72]">
                  Currently, PuppyPro supports training one dog at a time. Multi-dog support is
                  on our roadmap for a future update!
                </p>
              </div>

              <div>
                <h3 className="font-bold text-[#2D3436] mb-2">How do I change my daily training goal?</h3>
                <p className="text-[#636e72]">
                  Go to Settings and tap "Training Goals" to adjust how many training sessions
                  you want to complete each day.
                </p>
              </div>

              <div>
                <h3 className="font-bold text-[#2D3436] mb-2">Why aren't my notifications working?</h3>
                <p className="text-[#636e72]">
                  Make sure notifications are enabled both in the app (Settings → Notifications)
                  and in your iOS Settings (Settings → PuppyPro → Notifications).
                </p>
              </div>
            </div>
          </div>

          {/* Response Time */}
          <div className="bg-[#27ae60]/10 p-6 rounded-2xl text-center">
            <p className="text-[#27ae60] font-medium">
              ⏱️ We typically respond within 24-48 hours
            </p>
          </div>
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
