import "../styles/globals.css";
import "../styles/prism.css";
import "katex/dist/katex.min.css";
import type { AppProps } from "next/app";

function MyApp({ Component, pageProps }: AppProps) {
  return <Component {...pageProps} />;
}

export default MyApp;
