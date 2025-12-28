import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";

const faqs = [
  {
    question: "Is this really a one-time payment? No hidden fees?",
    answer: `Yes, really. You pay once, you own it forever. No subscription. No "introductory pricing" that jumps after a month. No sneaky auto-renewals. The price you see on the checkout page is the only price you'll ever pay. We'll never charge your card again unless you explicitly buy something else from us.

We built this app because we were tired of subscription traps. We're not about to become one.`,
  },
  {
    question: "Do I need to create an account?",
    answer: `Nope. Download the app, open it, add your dog, start training. That's it. No email required. No password to remember. No verification codes. No marketing emails.

Your data stays on your device (and syncs via iCloud if you choose). We don't have a server full of your personal information because we don't need one.`,
  },
  {
    question: "How many dogs can I add?",
    answer: `Puppy Plan: 1 dog
Pack Leader & Family Plans: Unlimited dogs

With Pack Leader or Family, add as many dogs as you want. 2 dogs, 5 dogs, 12 dogs. Foster dogs. Dogs you're pet-sitting. That neighbor's dog you're helping train. No per-dog fees. No nagging to upgrade. Just add them.`,
  },
  {
    question: "Does it work offline?",
    answer: `100%. Every feature works without an internet connection. Log training sessions at the park. Use the built-in clicker at the beach. Review your progress in the middle of nowhere. Everything syncs automatically when you're back online.

We built this because the best training happens outside, where WiFi doesn't.`,
  },
  {
    question: "What if I change phones?",
    answer: `Your data follows you. All your training data syncs through iCloud. Get a new iPhone? Just download the app and sign into your iCloud account. Everything will be there: your dogs, your training history, your progress, your notes.

For Family Plan users, this also means easy sharing between family members.`,
  },
  {
    question: "Is there a free trial?",
    answer: `No, and here's why. Free trials are how other apps trick you into subscriptions. "Start your free trial" becomes "$47 charged to your card" three days later.

Instead, we offer a 30-day money-back guarantee. Buy the app, use it fully, and if you don't love it, email us within 30 days for a complete refund. No questions asked, no hoops to jump through. You get to try everything with zero risk.`,
  },
  {
    question: "How is this different from other dog training apps?",
    answer: `The biggest difference? We respect your wallet. You pay once, you own it forever. No surprise charges. No billing traps. No "cancel before day 3 or else."

Compare: One-time payment ($19-59) vs. Subscription ($10-47/month). 2-year cost with us: $39. With them: up to $1,128. We don't require an account. We support unlimited dogs. We work fully offline. And we include a built-in clicker.`,
  },
  {
    question: "What's included in lifetime updates?",
    answer: `Everything we build, you get. When we add new features, new commands, new training guides, or make improvements, you get them automatically. No upgrade fees. No "premium tier" unlock costs.

Lifetime means lifetime. As long as we're updating the app, you're getting those updates at no additional cost.

Current roadmap includes: Video tutorials for complex commands, integration with smart treat dispensers, training challenges and achievements, and multi-language support. All of these will be free for existing customers.`,
  },
];

export function FAQ() {
  return (
    <section id="faq" className="py-16 md:py-20 lg:py-24">
      <div className="container mx-auto px-4 md:px-6 lg:px-8">
        <div className="mx-auto max-w-3xl">
          {/* Section Header */}
          <div className="mb-12 text-center">
            <h2 className="text-2xl font-bold tracking-tight md:text-3xl lg:text-4xl">
              Questions? We&apos;ve Got Answers.
            </h2>
            <p className="mt-4 text-muted-foreground">
              Everything you need to know about training your dog with our app.
            </p>
          </div>

          {/* Accordion */}
          <Accordion type="single" collapsible className="w-full">
            {faqs.map((faq, index) => (
              <AccordionItem key={index} value={`item-${index}`} className="border-b border-border">
                <AccordionTrigger className="py-4 text-left text-base font-medium hover:no-underline md:text-lg">
                  {faq.question}
                </AccordionTrigger>
                <AccordionContent className="pb-4 text-muted-foreground whitespace-pre-line">
                  {faq.answer}
                </AccordionContent>
              </AccordionItem>
            ))}
          </Accordion>

          {/* Contact */}
          <div className="mt-10 text-center">
            <p className="text-muted-foreground">
              Still have questions? Email us at{" "}
              <a href="mailto:support@puppypro.app" className="font-medium text-primary hover:underline">
                support@puppypro.app
              </a>
              {" "}and we&apos;ll get back to you within 24 hours.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
}
