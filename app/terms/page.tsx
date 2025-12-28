import { Metadata } from "next";
import Link from "next/link";
import { ArrowLeft, Dog } from "lucide-react";
import { Button } from "@/components/ui/button";

export const metadata: Metadata = {
  title: "Terms of Service | Puppy Pro",
  description: "Terms of Service for Puppy Pro. Simple terms for a simple app - pay once, own forever, with a 30-day money-back guarantee.",
};

export default function TermsPage() {
  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="sticky top-0 z-50 w-full border-b border-border/40 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
        <div className="container mx-auto flex h-16 items-center justify-between px-4 md:px-6">
          <Link href="/" className="flex items-center gap-2">
            <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary">
              <Dog className="h-5 w-5 text-primary-foreground" />
            </div>
            <span className="text-lg font-semibold">Puppy Pro</span>
          </Link>
          <Button variant="ghost" size="sm" asChild>
            <Link href="/">
              <ArrowLeft className="mr-2 h-4 w-4" />
              Back to Home
            </Link>
          </Button>
        </div>
      </header>

      {/* Content */}
      <main className="container mx-auto px-4 py-12 md:px-6 md:py-16">
        <div className="mx-auto max-w-3xl">
          <h1 className="text-3xl font-bold tracking-tight md:text-4xl">Terms of Service</h1>
          <p className="mt-4 text-muted-foreground">Last updated: January 2025</p>

          <div className="mt-8 space-y-8 text-foreground">
            <section>
              <h2 className="text-xl font-semibold">Agreement to Terms</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                By downloading, installing, or using Puppy Pro (&quot;the App&quot;), you agree to be bound
                by these Terms of Service. If you do not agree to these terms, please do not use the App.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">License to Use</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                Upon purchase, we grant you a non-exclusive, non-transferable, revocable license to use the App
                for personal, non-commercial purposes. This license is valid for the lifetime of the App and
                includes all future updates at no additional cost.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">One-Time Purchase</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                Puppy Pro is sold as a one-time purchase. There are no subscriptions, recurring fees,
                or in-app purchases required to access any features. Your purchase includes:
              </p>
              <ul className="mt-3 list-disc pl-6 space-y-2 text-muted-foreground">
                <li>Full access to all current features</li>
                <li>All future updates and new features</li>
                <li>Unlimited dogs (Pack Leader and Family plans)</li>
                <li>Email support</li>
              </ul>
            </section>

            <section>
              <h2 className="text-xl font-semibold">30-Day Money-Back Guarantee</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                We offer a 30-day money-back guarantee on all purchases. If you are not satisfied with the App
                for any reason, contact us at support@puppypro.app within 30 days of purchase for a
                full refund. Refunds are processed through Apple&apos;s App Store refund system.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Acceptable Use</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                You agree to use the App only for its intended purpose: tracking and managing dog training
                activities. You may not:
              </p>
              <ul className="mt-3 list-disc pl-6 space-y-2 text-muted-foreground">
                <li>Reverse engineer, decompile, or disassemble the App</li>
                <li>Modify, adapt, or create derivative works of the App</li>
                <li>Distribute, sell, or sublicense the App to third parties</li>
                <li>Use the App for any illegal or unauthorized purpose</li>
              </ul>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Your Content</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                All content you create within the App (dog profiles, training logs, notes, photos) remains
                your property. We do not claim any ownership over your content. Your content is stored locally
                on your device and optionally synced through your iCloud account.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Disclaimer of Warranties</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                The App is provided &quot;as is&quot; without warranties of any kind, either express or implied. While we
                strive to provide helpful dog training tools, we do not guarantee any specific training outcomes.
                The App is a tracking and organizational tool, not a substitute for professional dog training advice.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Limitation of Liability</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                To the maximum extent permitted by law, we shall not be liable for any indirect, incidental,
                special, consequential, or punitive damages, including loss of data, arising out of or related
                to your use of the App.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Updates to Terms</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                We may update these Terms of Service from time to time. We will notify you of any material
                changes by updating the &quot;Last updated&quot; date. Continued use of the App after changes constitutes
                acceptance of the updated terms.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Governing Law</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                These terms shall be governed by and construed in accordance with applicable laws, without
                regard to conflict of law principles.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Contact</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                For questions about these Terms of Service, please contact us at{" "}
                <a href="mailto:support@puppypro.app" className="text-primary hover:underline">
                  support@puppypro.app
                </a>
              </p>
            </section>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="border-t border-border py-8">
        <div className="container mx-auto px-4 text-center text-sm text-muted-foreground">
          <p>&copy; {new Date().getFullYear()} Puppy Pro. All rights reserved.</p>
          <div className="mt-2 flex justify-center gap-4">
            <Link href="/privacy" className="hover:text-foreground">Privacy</Link>
            <Link href="/terms" className="hover:text-foreground">Terms</Link>
            <Link href="/cookies" className="hover:text-foreground">Cookies</Link>
          </div>
        </div>
      </footer>
    </div>
  );
}
